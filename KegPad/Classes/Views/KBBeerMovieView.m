//
//  KBBeerMovieView.m
//  KegPad
//
//  Created by Gabriel Handford on 7/29/10.
//  Copyright 2010 Yelp. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "KBBeerMovieView.h"


@implementation KBBeerMovieView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [moviePlayerController_ release];
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  movieView_.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)_playbackDidFinish:(NSNotification *)notification {
  KBDebug(@"Playback finished: %@", notification);
}

- (void)play:(NSURL *)URL {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
  if (!moviePlayerController_) {
    moviePlayerController_ = [[MPMoviePlayerController alloc] init];
  
    moviePlayerController_.scalingMode = MPMovieScalingModeAspectFill;
    moviePlayerController_.controlStyle = MPMovieControlStyleNone;
    movieView_ = [moviePlayerController_.view retain];
    
    // Mask
    CALayer *maskLayer = [CALayer layer];    
    maskLayer.frame = CGRectMake(0, 0, 768, 432);
    maskLayer.position = CGPointMake(0, 0);
    maskLayer.anchorPoint = CGPointMake(0,0);  
    UIImage *testImage = [UIImage imageNamed:@"top_gradient_mask.png"];
    [maskLayer setContents:(id)testImage.CGImage];
    self.layer.mask = maskLayer;
    
    [self addSubview:movieView_];
  }
  
  moviePlayerController_.currentPlaybackRate = 0.70;
  [moviePlayerController_ setContentURL:URL];
  [moviePlayerController_ play];
}

- (void)play {
  // 768x432 will maintain aspect on 640x360
  NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"BeerReverse400" ofType:@"mov"];
  NSURL *URL = [NSURL fileURLWithPath:moviePath];
  [self play:URL];
}

- (void)stop {
  [moviePlayerController_ stop];
}

@end

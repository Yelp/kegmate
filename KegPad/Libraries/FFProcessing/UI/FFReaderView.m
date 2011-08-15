//
//  FFReaderView.m
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFReaderView.h"

#import "FFUtils.h"
#import "FFAVCaptureSessionReader.h"
#import "FFGLDrawable.h"

@interface FFReaderView ()
@property (retain, nonatomic) FFGLDrawable *drawable;
@property (retain, nonatomic) FFGLDrawable *secondaryDrawable;
@end


@implementation FFReaderView

@synthesize delegate=_delegate, playerView=_playerView, videoFrameSize=_videoFrameSize, drawable=_drawable, secondaryDrawable=_secondaryDrawable;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor blackColor];
  }
  return self;
}

- (void)dealloc {
  [_playerView stopAnimation];
  _playerView.delegate = nil;
  [_playerView release];
  [_drawable release];
  [_secondaryDrawable release];
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (_videoFrameSize.width > 0) {
    _playerView.frame = FFCGRectConvert(self.frame, _videoFrameSize, UIViewContentModeScaleAspectFit);
  } else {
    _playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  }
}

- (void)setVideoFrameSize:(CGSize)videoFrameSize {
  _videoFrameSize = videoFrameSize;
  [self setNeedsLayout];
}

- (FFPlayerView *)playerView {
  if (!_playerView) {
    _playerView = [[FFPlayerView alloc] init];  
    _playerView.delegate = self;
    [self addSubview:_playerView];
    [_playerView startAnimation];
  }
  return _playerView;
}

- (void)setReader:(id<FFReader>)reader {
  if (_drawable) [[self playerView] removeDrawable:_drawable];  
  _drawable = [[FFGLDrawable alloc] initWithReader:reader filter:nil];
  [[self playerView] addDrawable:_drawable];
  [self setNeedsLayout];
}

- (void)setSecondaryReader:(id<FFReader>)secondaryReader {
  if (_secondaryDrawable) [[self playerView] removeDrawable:_secondaryDrawable];  
  _secondaryDrawable = [[FFGLDrawable alloc] initWithReader:secondaryReader filter:nil];
  _secondaryDrawable.textureFrame = CGRectMake(10, 50, 144, 192);
  [[self playerView] addDrawable:_secondaryDrawable];
  [self setNeedsLayout];
}

- (void)playerViewDidTouch:(FFPlayerView *)playerView {
  [_delegate readerViewDidTouch:self];
}

@end

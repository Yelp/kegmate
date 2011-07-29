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


@implementation FFReaderView

@synthesize delegate=_delegate, playerView=_playerView;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.backgroundColor = [UIColor blackColor];
    _playerView = [[FFPlayerView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];  
    _playerView.delegate = self;
    FFGLDrawable *drawable = [[FFGLDrawable alloc] init];
    _playerView.drawable = drawable;
    [drawable release];
    [self addSubview:_playerView];
  }
  return self;
}

- (void)dealloc {
  [_playerView stopAnimation];
  _playerView.delegate = nil;
  [_playerView release];
  [super dealloc];
}

- (void)setReader:(id<FFReader>)reader {
  ((FFGLDrawable *)_playerView.drawable).reader = reader;
}

- (void)startAnimation {
  [_playerView startAnimation];
}

- (void)stopAnimation {
  [_playerView stopAnimation];
}

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions {
  [(FFGLDrawable *)_playerView.drawable setImagingOptions:imagingOptions];
}

- (void)playerViewDidTouch:(FFPlayerView *)playerView {
  [_delegate readerViewDidTouch:self];
}

@end

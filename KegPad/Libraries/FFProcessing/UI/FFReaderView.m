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

@synthesize delegate=_delegate, playerView=_playerView, videoFrameSize=_videoFrameSize;

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor blackColor];
    _playerView = [[FFPlayerView alloc] init];  
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

- (void)layoutSubviews {
  [super layoutSubviews];
  if (_videoFrameSize.width > 0) {
    _playerView.frame = FFCGRectConvert(self.frame, _videoFrameSize, UIViewContentModeScaleAspectFit);    
    //_playerView.frame = CGRectMake(roundf((self.frame.size.width - width)/2.0), roundf((self.frame.size.height - height)/2.0), width, height);
  } else {
    _playerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  }
}

- (void)setVideoFrameSize:(CGSize)videoFrameSize {
  _videoFrameSize = videoFrameSize;
  [self setNeedsLayout];
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

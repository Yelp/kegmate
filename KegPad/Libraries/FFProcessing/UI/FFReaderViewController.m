//
//  FFReaderViewController.m
//  PBR
//
//  Created by Gabriel Handford on 11/18/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFReaderViewController.h"

#import "FFUtils.h"
#import "FFAVCaptureSessionReader.h"
#import "FFGLDrawable.h"


@interface FFReaderViewController ()
- (void)_reload;
@end

@implementation FFReaderViewController

@synthesize delegate=_delegate;

- (id)initWithReader:(id<FFReader>)reader {
  if ((self = [self init])) {
    _reader = [reader retain];
  }
  return self;
}

- (void)dealloc {
  [_reader release];
  [_playerView release];
  [super dealloc];
}

- (void)loadView {
  if (!_playerView) {    
    _playerView = [[FFPlayerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];  
    _playerView.delegate = self;
  }
  FFDebug(@"Setting player view");
  self.view = _playerView;
  [self _reload];
}

- (void)_reload {
  FFGLDrawable *drawable = [[FFGLDrawable alloc] initWithReader:_reader filter:nil];
  [_playerView setDrawable:drawable];
  [drawable release];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [_playerView startAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_playerView stopAnimation];
}

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions {
  [self view];
  FFGLDrawable *drawable = [[_playerView drawables] gh_firstObject];
  [drawable setImagingOptions:imagingOptions];
}

- (void)playerViewDidTouch:(FFPlayerView *)playerView {
  [_delegate readerViewControllerDidTouch:self];
}

@end
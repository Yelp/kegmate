//
//  PBRCameraCaptureController.h
//  PBR
//
//  Created by Gabriel Handford on 11/18/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFPlayerView.h"
#import "FFGLImaging.h"


@class FFReaderViewController;

@protocol FFReaderViewControllerDelegate <NSObject>
- (void)readerViewControllerDidTouch:(FFReaderViewController *)readerViewController;
@end

@interface FFReaderViewController : UIViewController <FFPlayerViewDelegate> {
  FFPlayerView *_playerView;
  
  id<FFReader> _reader;
  
  id<FFReaderViewControllerDelegate> _delegate;
}

@property (assign, nonatomic) id<FFReaderViewControllerDelegate> delegate;

- (id)initWithReader:(id<FFReader>)reader;

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions;

@end
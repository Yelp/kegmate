//
//  FFReaderView.h
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFPlayerView.h"
#import "FFGLImaging.h"

@class FFReaderView;

@protocol FFReaderViewDelegate <NSObject>
- (void)readerViewDidTouch:(FFReaderView *)readerView;
@end

@interface FFReaderView : UIView <FFPlayerViewDelegate> {
  FFPlayerView *_playerView;
  
  id<FFReaderViewDelegate> _delegate;
}

@property (assign, nonatomic) id<FFReaderViewDelegate> delegate;

@property (readonly, nonatomic) FFPlayerView *playerView;

- (void)setReader:(id<FFReader>)reader;

- (void)setImagingOptions:(FFGLImagingOptions)imagingOptions;

- (void)startAnimation;

- (void)stopAnimation;

@end
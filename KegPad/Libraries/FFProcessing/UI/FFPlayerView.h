//
//  FFProcessingView.h
//  Steer
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "GHGLView.h"
#import "FFReader.h"

@class FFPlayerView;

@protocol FFPlayerViewDelegate <NSObject>
- (void)playerViewDidTouch:(FFPlayerView *)playerView;
@end

@interface FFPlayerView : GHGLView {
  id<FFPlayerViewDelegate> _delegate;
}

@property (assign, nonatomic) id<FFPlayerViewDelegate> delegate;

@end

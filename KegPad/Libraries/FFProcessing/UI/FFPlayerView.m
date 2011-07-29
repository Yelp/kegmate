//
//  FFProcessingView.m
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#import "FFPlayerView.h"
#import "FFUtils.h"

#import "FFReader.h"
#import "FFGLDrawable.h"


@implementation FFPlayerView

@synthesize delegate=_delegate;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
  [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  FFDebug(@"Touches ended");
  [_delegate playerViewDidTouch:self];
}


@end

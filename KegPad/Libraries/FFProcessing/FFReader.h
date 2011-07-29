//
//  FFReader.h
//  FFMP
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReading.h"

@protocol FFReader <NSObject>
- (BOOL)start:(NSError **)error;
- (FFVFrameRef)nextFrame:(NSError **)error;
- (void)close;
@end

@interface FFReader : NSObject <FFReader> {
  id<FFReading> _reading;
  
  FFVFrameRef _frame;
  
  BOOL _started;
}

- (id)initWithReading:(id<FFReading>)reading;

@end

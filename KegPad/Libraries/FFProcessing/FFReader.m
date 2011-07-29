//
//  FFReader.m
//  FFMP
//
//  Created by Gabriel Handford on 3/8/10.
//  Copyright 2010. All rights reserved.
//

#import "FFReader.h"

#import "FFUtils.h"
#import "FFEncoderOptions.h"

@implementation FFReader

- (id)initWithReading:(id<FFReading>)reading {
  if ((self = [self init])) {
    _reading = [reading retain];
  }
  return self;
}

- (void)dealloc {
  [self close];
  [super dealloc];
}

- (void)close {
  [_reading close];
  [_reading release];
  _reading = nil;
  FFVFrameRelease(_frame);  
}

- (BOOL)start:(NSError **)error {
  if (!_started) {
    _started = YES;    
    [_reading start];
  }
  
  if (_frame == NULL) {
    _frame = FFVFrameCreate([_reading format]);
  }
  return YES;
}

- (FFVFrameRef)nextFrame:(NSError **)error {  
  if (!_started) {
    if (![self start:error])
      return NULL;
    _started = YES;
  }
  if (_frame == NULL) return NULL;
  
  if (![_reading readFrame:_frame]) return _frame;
  
  return _frame;
}

@end

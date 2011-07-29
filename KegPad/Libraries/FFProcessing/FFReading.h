//
//  FFReading.h
//  FFProcessing
//
//  Created by Gabriel Handford on 6/11/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"

@protocol FFReading <NSObject>
- (FFVFormat)format;
- (BOOL)readFrame:(FFVFrameRef)frame;
- (void)start;
- (void)close;
@end

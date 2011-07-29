//
//  FFFilter.h
//  FFProcessing
//
//  Created by Gabriel Handford on 4/28/10.
//  Copyright 2010. All rights reserved.
//

#import "FFTypes.h"

@protocol FFFilter <NSObject>
- (FFVFrameRef)filterFrame:(FFVFrameRef)frame error:(NSError **)error;
@end


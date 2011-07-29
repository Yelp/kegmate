//
//  PBRAVCaptureService.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FFAVCaptureSessionReader.h"
#import "PBRService.h"


@interface PBRAVCaptureService : PBRService {
  FFAVCaptureSessionReader *_videoCapture;

  NSTimer *_timer;  
}

- (BOOL)startStreamingVideo;
- (void)stopStreamingVideo;

+ (BOOL)isSupported;

@end

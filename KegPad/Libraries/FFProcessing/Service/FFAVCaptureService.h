//
//  FFAVCaptureService.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011. All rights reserved.
//

#import "FFAVCaptureSessionReader.h"
#import "FFService.h"


@interface FFAVCaptureService : FFService {
  FFAVCaptureSessionReader *_videoCapture;

  NSTimer *_timer;  
}

- (BOOL)startStreamingVideo;
- (void)stopStreamingVideo;

+ (BOOL)isSupported;

- (NSString *)address;
- (NSUInteger)port;

@end

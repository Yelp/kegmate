//
//  PBRAVCaptureService.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRAVCaptureService.h"
#import "PBRDefines.h"
#import "PBRStreamDefines.h"


@implementation PBRAVCaptureService

- (void)dealloc {
  [self stopStreamingVideo];
  [super dealloc];
}

+ (BOOL)isSupported {
  return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 0;
}

- (NSUInteger)port {
  return self.server.port;
}

- (NSString *)address {
  return self.server.address;
}

- (void)didAcceptConnection:(PBRConnection *)connection {
  [self startStreamingVideo];
}

- (void)didCloseConnection:(PBRConnection *)connection {
  if ([self.connections count] == 0) {
    [self stopStreamingVideo];
  }
}

- (BOOL)startStreamingVideo {
  if (_timer) return NO;

  PBRDebug(@"Starting AV writer");  
  _videoCapture = [[FFAVCaptureSessionReader alloc] init];
  [_videoCapture start:nil];
  _timer = [NSTimer scheduledTimerWithTimeInterval:kStreamWriteInterval target:self selector:@selector(writeNextFrameToStream) 
                                          userInfo:nil repeats:YES];
  return YES;
}

- (void)stopStreamingVideo {
  PBRDebug(@"Stopping AV writer");
  [_timer invalidate];
  _timer = nil;
  [_videoCapture close];
  [_videoCapture release];
  _videoCapture = nil;
}

- (void)writeNextFrameToStream {
  FFVFrameRef frame = [_videoCapture nextFrame:nil];
  if (frame != NULL) {
    NSData *messageData = JPEGDataCreateFromFFVFrame(frame, kJPEGQuality);
    [self writeMessage:messageData];
  }
}

@end

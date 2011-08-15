//
//  FFAVCaptureService.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011. All rights reserved.
//

#import "FFAVCaptureService.h"
#import "FFUtils.h"
#import "FFStreamDefines.h"


@implementation FFAVCaptureService

@synthesize videoCapture=_videoCapture;

- (void)dealloc {
  [self stopCapture];
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

- (void)didAcceptConnection:(FFConnection *)connection {
  [self startCapture];
}

- (void)didCloseConnection:(FFConnection *)connection {
  if ([self connectionCount] == 0) {
    [self stopCapture];
  }
}

- (FFAVCaptureSessionReader *)videoCapture {
  if (!_videoCapture) {
    _videoCapture = [[FFAVCaptureSessionReader alloc] init];
  }
  return _videoCapture;
}

- (BOOL)startCapture {
  FFAVCaptureSessionReader *videoCapture = [self videoCapture];
  if (![videoCapture isStarted]) {
    FFDebug(@"Starting AV writer");
    [videoCapture start:nil];
  }

  if (_timer) return NO;
  _timer = [NSTimer scheduledTimerWithTimeInterval:kStreamWriteInterval target:self selector:@selector(writeNextFrameToStream) 
                                          userInfo:nil repeats:YES];
  return YES;
}

- (void)stopCapture {
  FFDebug(@"Stopping AV writer");
  [_timer invalidate];
  _timer = nil;
  [_videoCapture close];
  [_videoCapture release];
  _videoCapture = nil;
}

- (void)writeNextFrameToStream {
  if ([self connectionCount] <= 0) return;
  
  FFVFrameRef frame = [_videoCapture nextFrame:nil];
  if (frame != NULL) {
    NSData *messageData = JPEGDataCreateFromFFVFrame(frame, kJPEGQuality);
    [self writeMessage:messageData];
  }
}

@end

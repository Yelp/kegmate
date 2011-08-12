//
//  FFAVCaptureServiceClient.m
//  KegPad
//
//  Created by Gabriel Handford on 8/8/11.
//  Copyright 2011. All rights reserved.
//

#import "FFAVCaptureServiceClient.h"
#import "FFUtils.h"

@interface FFAVCaptureServiceClient ()
@property (retain, nonatomic) NSNetService *service;
- (void)_closeConnection;
@end


@implementation FFAVCaptureServiceClient

@synthesize service=_service;

- (id)initWithService:(NSNetService *)service {
  if ((self = [super init])) {
    _service = [service retain];
  }
  return self;
}

- (void)dealloc {
  [self _closeConnection];
  [_service release];
  [super dealloc];
}

- (void)_closeConnection {
  _connection.delegate = nil;
  [_connection close];
  [_connection release];
  _connection = nil;
}

- (void)close {
  [self _closeConnection];
}

- (BOOL)connect {
  [self _closeConnection];  
  if (_service) {
    _connection = [[FFConnection alloc] init];
    _connection.delegate = self;
    return [_connection openWithService:_service];
  }
  return NO;
}

- (void)connectionDidClose:(FFConnection *)connection {
  [[self gh_proxyAfterDelay:4.0] reconnect];
}

- (void)connection:(FFConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length {
  [self readBytes:bytes length:length];
}

@end

//
//  FFService.m
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFService.h"
#import "FFUtils.h"


@implementation FFService

@synthesize connections=_connections, server=_server;

- (id)init {
  if ((self = [super init])) {
    _connections = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc {
  [self stop];
  [_connections release];
  [super dealloc];
}

- (BOOL)start:(NSError **)error {
  NSAssert(!_server, @"Already started");
  
  _server = [[FFTCPServer alloc] init];
  _server.delegate = self;
  if (![_server start:nil]) {
    FFDebug(@"Couldn't start TCP server");
    return NO;
  }  
  return YES;
}

- (void)stop {
  _server.delegate = nil;
  [_server stop];
  [_server release];
  _server = nil;
  
  for (FFConnection *connection in _connections) {
    [connection close];
    connection.delegate = nil;
  }
  [_connections removeAllObjects];
}

- (void)close {
  [self stop];
}

- (BOOL)enableBonjourWithDomain:(NSString *)domain serviceType:(NSString *)serviceType name:(NSString *)name {
  if (![_server enableBonjourWithDomain:domain applicationProtocol:serviceType name:name]) {
    FFDebug(@"Couldn't enable bonjour");
    return NO;
  }
  FFDebug(@"Enabled bonjour");
  return YES;
}

- (void)disableBonjour {
  [_server disableBonjour];
}

- (void)didAcceptConnectionForServer:(FFTCPServer *)server address:(NSString *)address inputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
  FFDebug(@"Accepted connection from %@", address);
  
  FFConnection *connection = [[FFConnection alloc] init];
  connection.delegate = self;
  [connection openWithInputStream:inputStream outputStream:outputStream];
  [_connections addObject:connection];
  [connection release];
  [self didAcceptConnection:connection];
}

- (void)writeMessage:(NSData *)message {
  for (FFConnection *connection in _connections) {
    [connection writeMessage:message];
  }
}

- (NSInteger)connectionCount {
  if (!_connections) return 0;
  return [_connections count];
}

#pragma mark -

- (void)connection:(FFConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length { }

- (void)connectionDidClose:(FFConnection *)connection {
  [connection retain];
  [_connections removeObject:connection];
  [self didCloseConnection:connection];
  [connection autorelease];
}

#pragma mark -

- (void)didAcceptConnection:(FFConnection *)connection {
  // For subclasses
}

- (void)didCloseConnection:(FFConnection *)connection {
  // For subclasses
}

@end

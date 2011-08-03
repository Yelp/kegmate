//
//  PBRService.m
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "PBRService.h"
#import "PBRDefines.h"


@implementation PBRService

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
  
  _server = [[PBRTCPServer alloc] init];
  _server.delegate = self;
  if (![_server start:nil]) {
    PBRDebug(@"Couldn't start TCP server");
    return NO;
  }  
  return YES;
}

- (void)stop {
  _server.delegate = nil;
  [_server stop];
  [_server release];
  _server = nil;
  
  for (PBRConnection *connection in _connections) {
    [connection close];
    connection.delegate = nil;
  }
  [_connections removeAllObjects];
}

- (void)close {
  [self stop];
}

- (BOOL)enableBonjourWithName:(NSString *)name {
  if (![_server enableBonjourWithDomain:@"local" applicationProtocol:@"_kegpad._tcp." name:name]) {
    PBRDebug(@"Couldn't enable bonjour");
    return NO;
  }
  PBRDebug(@"Enabled bonjour");
  return YES;
}

- (void)disableBonjour {
  [_server disableBonjour];
}

- (void)didAcceptConnectionForServer:(PBRTCPServer *)server address:(NSString *)address inputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
  PBRDebug(@"Accepted connection from %@", address);
  
  PBRConnection *connection = [[PBRConnection alloc] init];
  connection.delegate = self;
  [connection openWithInputStream:inputStream outputStream:outputStream];
  [_connections addObject:connection];
  [connection release];
  [self didAcceptConnection:connection];
}

- (void)writeMessage:(NSData *)message {
  for (PBRConnection *connection in _connections) {
    [connection writeMessage:message];
  }
}

#pragma mark -

- (void)connection:(PBRConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length { }

- (void)connectionDidClose:(PBRConnection *)connection {
  [connection retain];
  [_connections removeObject:connection];
  [self didCloseConnection:connection];
  [connection autorelease];
}

#pragma mark -

- (void)didAcceptConnection:(PBRConnection *)connection {
  // For subclasses
}

- (void)didCloseConnection:(PBRConnection *)connection {
  // For subclasses
}

@end

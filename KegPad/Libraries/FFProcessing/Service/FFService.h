//
//  FFService.h
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFConnection.h"

#import "FFTCPServer.h"
#import "FFServiceBrowser.h"


@interface FFService : NSObject <FFConnectionDelegate, FFTCPServerDelegate> {
  NSMutableArray */*of FFConnection*/_connections; // For writing to
  
  FFTCPServer *_server;
}

@property (readonly, nonatomic) NSArray */*of FFConnection*/connections;
@property (readonly, nonatomic) FFTCPServer *server;

- (BOOL)start:(NSError **)error;
- (void)stop;
- (void)close;

- (BOOL)enableBonjourWithDomain:(NSString *)domain serviceType:(NSString *)serviceType name:(NSString *)name;

- (void)disableBonjour;

- (void)writeMessage:(NSData *)message;

- (NSInteger)connectionCount;

- (void)didAcceptConnection:(FFConnection *)connection; // For subclasses
- (void)didCloseConnection:(FFConnection *)connection; // For subclasses

@end

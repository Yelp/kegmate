//
//  PBRService.h
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "PBRConnection.h"

#import "PBRTCPServer.h"
#import "PBRServiceBrowser.h"


@interface PBRService : NSObject <PBRConnectionDelegate, PBRTCPServerDelegate> {
  NSMutableArray */*of PBRConnection*/_connections; // For writing to
  
  PBRTCPServer *_server;
}

@property (readonly, nonatomic) NSArray */*of PBRConnection*/connections;

- (BOOL)start:(NSError **)error;
- (void)stop;
- (void)close;

- (BOOL)enableBonjourWithName:(NSString *)name;

- (void)disableBonjour;

- (void)writeMessage:(NSData *)message;

- (void)didAcceptConnection:(PBRConnection *)connection; // For subclasses
- (void)didCloseConnection:(PBRConnection *)connection; // For subclasses

@end

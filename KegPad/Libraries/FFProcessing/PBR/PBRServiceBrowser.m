//
//  PBRServiceBrowser.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRServiceBrowser.h"
#import "PBRDefines.h"
#import "PBRStreamUtils.h"
#include <arpa/inet.h>


@implementation PBRServiceBrowser

@synthesize delegate=_delegate, searching=_searching;

- (void)dealloc {
  [self stop];
  [super dealloc];
}

- (BOOL)search {
  PBRDebug(@"Starting service browser");
  if (!_serviceBrowser) {
    _serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [_serviceBrowser setDelegate:self];
  }
  [_serviceBrowser searchForServicesOfType:@"_kegpad._tcp." inDomain:@"local"];  
  _searching = YES;
  return YES;
}

- (void)stop {
  PBRDebug(@"Stopping service browser");
  for (NSNetService *service in _resolvingServices) {
    [service setDelegate:nil];
  }
  [_resolvingServices removeAllObjects];
  [_resolvingServices release];
  _resolvingServices = nil;
  
  [_serviceBrowser setDelegate:nil];
  [_serviceBrowser stop];
  [_serviceBrowser release];
  _serviceBrowser = nil;
  _searching = NO;
}

- (void)stopResolvingService:(NSNetService *)service {
  [service stop];
  [service setDelegate:nil];
  [_resolvingServices removeObject:service];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didFindService:(NSNetService *)netService moreComing:(BOOL)moreComing {
  PBRDebug(@"Found service: %@", netService);
  
  if (!_resolvingServices) _resolvingServices = [[NSMutableArray alloc] init];
  [_resolvingServices addObject:netService];  
  [netService resolveWithTimeout:5.0];
  [netService setDelegate:self];
}

#pragma mark NetService Resolve

- (BOOL)isValidService:(NSNetService *)netService {
  NSSet *serviceAddresses = [PBRStreamUtils addressStringsFromNetService:netService];
  PBRDebug(@"Service addresses: %@", serviceAddresses);
  if ([serviceAddresses count] == 0) {
    PBRDebug(@"No addresses, skipping");
    return NO;
  }
  
  if ([PBRStreamUtils containsCurrentAddress:serviceAddresses]) {
    PBRDebug(@"Found ourselves, skipping");
    return NO;
  }

  return YES;
}

- (void)netServiceDidResolveAddress:(NSNetService *)netService {
  PBRDebug(@"Did resolve address: %@", netService);
  if ([self isValidService:netService]) {
    [_delegate searchService:self didFindAndResolveService:netService];  
  }
  [self stopResolvingService:netService];
}

- (void)netService:(NSNetService *)netService didNotResolve:(NSDictionary *)errorInfo {
  PBRDebug(@"Did not resolve, %@", errorInfo);
  [self stopResolvingService:netService];
  //[_delegate searchService:self didError:nil]; // TODO(gabe): Create NSError
}

#pragma mark NetServiceBrowser Search

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
  PBRDebug(@"Did not search, %@", errorInfo);
  [self stop];
  [_delegate searchService:self didError:nil]; // TODO(gabe): Create NSError
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  [self stop];
  _searching = NO;
}

@end

//
//  FFServiceBrowser.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011. All rights reserved.
//

#import "FFServiceBrowser.h"
#import "FFUtils.h"
#import "FFStreamUtils.h"
#include <arpa/inet.h>


@implementation FFServiceBrowser

@synthesize delegate=_delegate, searching=_searching;

- (id)initWithServiceType:(NSString *)serviceType domain:(NSString *)domain {
  if ((self = [super init])) {
    _serviceType = [serviceType retain];
    _domain = [domain retain];
  }
  return self;
}

- (void)dealloc {
  [self stop];
  [_serviceType release];
  [_domain release];
  [super dealloc];
}

- (BOOL)search {
  FFDebug(@"Starting service browser");
  if (!_serviceBrowser) {
    _serviceBrowser = [[NSNetServiceBrowser alloc] init];
    [_serviceBrowser setDelegate:self];
  }
  [_serviceBrowser searchForServicesOfType:_serviceType inDomain:_domain];  
  _searching = YES;
  return YES;
}

- (void)stop {
  FFDebug(@"Stopping service browser");
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
  FFDebug(@"Found service: %@", netService);
  
  if (!_resolvingServices) _resolvingServices = [[NSMutableArray alloc] init];
  [_resolvingServices addObject:netService];  
  [netService resolveWithTimeout:5.0];
  [netService setDelegate:self];
}

#pragma mark NetService Resolve

- (BOOL)isValidService:(NSNetService *)netService {
  NSSet *serviceAddresses = [FFStreamUtils addressStringsFromNetService:netService];
  FFDebug(@"Service addresses: %@", serviceAddresses);
  if ([serviceAddresses count] == 0) {
    FFDebug(@"No addresses, skipping");
    return NO;
  }
  
  if ([FFStreamUtils containsCurrentAddress:serviceAddresses]) {
    FFDebug(@"Found ourselves, skipping");
    return NO;
  }

  return YES;
}

- (void)netServiceDidResolveAddress:(NSNetService *)netService {
  FFDebug(@"Did resolve address: %@", netService);
  if ([self isValidService:netService]) {
    [_delegate searchService:self didFindAndResolveService:netService];  
  }
  [self stopResolvingService:netService];
}

- (void)netService:(NSNetService *)netService didNotResolve:(NSDictionary *)errorInfo {
  FFDebug(@"Did not resolve, %@", errorInfo);
  [self stopResolvingService:netService];
  //[_delegate searchService:self didError:nil]; // TODO(gabe): Create NSError
}

#pragma mark NetServiceBrowser Search

- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didNotSearch:(NSDictionary *)errorInfo {
  FFDebug(@"Did not search, %@", errorInfo);
  [self stop];
  [_delegate searchService:self didError:nil]; // TODO(gabe): Create NSError
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)netServiceBrowser {
  [self stop];
  _searching = NO;
}

@end

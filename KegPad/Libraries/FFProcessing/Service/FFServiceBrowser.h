//
//  FFServiceBrowser.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011. All rights reserved.
//

@class FFServiceBrowser;

@protocol FFServiceBrowserDelegate <NSObject>
- (void)searchService:(FFServiceBrowser *)searchService didFindAndResolveService:(NSNetService *)netService;
- (void)searchService:(FFServiceBrowser *)searchService didError:(NSError *)error;
@end



@interface FFServiceBrowser : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
  NSNetServiceBrowser *_serviceBrowser;
  
  NSMutableArray *_resolvingServices;
  
  NSString *_serviceType;
  NSString *_domain;
  
  BOOL _searching;
  
  id<FFServiceBrowserDelegate> _delegate;
}

@property (assign, nonatomic) id<FFServiceBrowserDelegate> delegate;
@property (readonly, nonatomic, getter=isSearching) BOOL searching;

- (id)initWithServiceType:(NSString *)serviceType domain:(NSString *)domain;

- (BOOL)search;

- (void)stop;

@end

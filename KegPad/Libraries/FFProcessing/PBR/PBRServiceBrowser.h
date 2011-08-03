//
//  PBRServiceBrowser.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class PBRServiceBrowser;

@protocol PBRServiceBrowserDelegate <NSObject>
- (void)searchService:(PBRServiceBrowser *)searchService didFindAndResolveService:(NSNetService *)netService;
- (void)searchService:(PBRServiceBrowser *)searchService didError:(NSError *)error;
@end



@interface PBRServiceBrowser : NSObject <NSNetServiceBrowserDelegate, NSNetServiceDelegate> {
  NSNetServiceBrowser *_serviceBrowser;
  
  NSMutableArray *_resolvingServices;
  
  BOOL _searching;
  
  id<PBRServiceBrowserDelegate> _delegate;
}

@property (assign, nonatomic) id<PBRServiceBrowserDelegate> delegate;
@property (readonly, nonatomic, getter=isSearching) BOOL searching;

- (BOOL)search;

- (void)stop;

@end

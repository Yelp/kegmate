//
//  KBKegTimeSearchViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBKegTimeSearchViewController.h"

#import "KBKegTimeViewController.h"
#import "PBRDefines.h"


@implementation KBKegTimeSearchNavigationController

@synthesize kegTimeSearchViewController=kegTimeSearchViewController_;

- (id)init {
  if ((self = [super init])) {
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    kegTimeSearchViewController_ = [[KBKegTimeSearchViewController alloc] init];
    [self pushViewController:kegTimeSearchViewController_ animated:NO];
  }
  return self;
}

- (void)dealloc {
  [kegTimeSearchViewController_ release];
  [super dealloc];
}

@end


@interface KBKegTimeSearchViewController ()
- (void)_refresh;
@end


@implementation KBKegTimeSearchViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"KegTime";
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(_refresh)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
    
    // For testing
    //[self addForm:[KBUIForm formWithTitle:@"Camera" text:nil target:self action:@selector(_camera) context:nil showDisclosure:YES] section:3];    
  }
  return self;
}

- (void)dealloc {
  _searchService.delegate = nil;
  [_searchService release];
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  if (!_searchService) {
    [self _refresh];
  }
}

- (void)close {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)_refresh {
  if (!_searchService) {
    _searchService = [[PBRServiceBrowser alloc] init];
    _searchService.delegate = self;
  }

  [self removeFromSection:1];
  [self reload];
  [_searchService search];
}

- (void)_camera {
  KBKegTimeViewController *kegTimeViewController = [[KBKegTimeViewController alloc] init];
  [kegTimeViewController enableCamera];
  [self.navigationController pushViewController:kegTimeViewController animated:YES];
  [kegTimeViewController release];
}

- (void)_kegPadSelect:(NSNetService *)netService {
  KBKegTimeViewController *kegTimeViewController = [[KBKegTimeViewController alloc] init];
  [kegTimeViewController setNetService:netService];
  [self.navigationController pushViewController:kegTimeViewController animated:YES];
  [kegTimeViewController release];
}

- (void)searchService:(PBRServiceBrowser *)searchService didFindAndResolveService:(NSNetService *)netService {
  for (KBUIForm *form in [self formsForSection:1]) {
    if ([[form.context name] isEqualToString:[netService name]]) {
      form.context = netService;
      KBDebug(@"Already have service");
      return;
    }
  }
  
  KBDebug(@"Adding: %@", netService.name);
  [self addForm:[KBUIForm formWithTitle:netService.name text:nil target:self action:@selector(_kegPadSelect:) context:netService showDisclosure:YES] section:1];    
  [self reload];  
}

- (void)searchService:(PBRServiceBrowser *)searchService didError:(NSError *)error {
  PBRDebug(@"Error: %@", error);
  //[self showAlertWithTitle:@"Error" message:@"We had a problem"]; // TODO(gabe): Real error
  [[_searchService gh_proxyAfterDelay:2] search];
}

@end

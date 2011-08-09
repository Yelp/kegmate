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
#import "KBApplication.h"
#import "PBRStreamUtils.h"
#import "KBKegTimeHost.h"


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
    
    [self addForm:[KBUIForm formWithTitle:@"Add Host" text:nil target:self action:@selector(_addHost) context:nil showDisclosure:YES] section:3];    
  }
  return self;
}

- (void)dealloc {
  _searchService.delegate = nil;
  [_searchService release];
  [_footerLabel release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (!_footerLabel) {
    _footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    _footerLabel.backgroundColor = [UIColor clearColor];
    _footerLabel.textAlignment = UITextAlignmentCenter;
  }
  self.tableView.tableFooterView = _footerLabel;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  PBRAVCaptureService *captureService = [[KBApplication sharedDelegate] captureService];
  _footerLabel.text = @"";
  if (captureService) {
    NSString *address = [PBRStreamUtils ipv4Address];
    _footerLabel.text = [NSString stringWithFormat:@"%@:%d", address, captureService.port];
  }
  
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

- (KBKegTimeViewController *)_kegTimeViewController {
  KBKegTimeViewController *kegTimeViewController = [[KBKegTimeViewController alloc] init];
  kegTimeViewController.videoSize = CGSizeMake(540, 720);
  [self.navigationController pushViewController:kegTimeViewController animated:YES];
  [kegTimeViewController release];
  return kegTimeViewController;
}

- (void)_kegPadSelectService:(NSNetService *)service {
  KBKegTimeViewController *kegTimeViewController = [self _kegTimeViewController];
  [kegTimeViewController connectToService:service];
}

- (void)_kegPadSelectHost:(KBKegTimeHost *)host {
  KBKegTimeViewController *kegTimeViewController = [self _kegTimeViewController];
  [kegTimeViewController connectToHost:host];
}

- (void)_addHost {
  KegTimeHostEditViewController *kegTimeHostEditViewController = [[KegTimeHostEditViewController alloc] init];
  kegTimeHostEditViewController.delegate = self;
  [self.navigationController pushViewController:kegTimeHostEditViewController animated:YES];
  [kegTimeHostEditViewController release];
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
  [self addForm:[KBUIForm formWithTitle:netService.name text:nil target:self action:@selector(_kegPadSelectService:) context:netService showDisclosure:YES] section:1];    
  [self reload];  
}

- (void)searchService:(PBRServiceBrowser *)searchService didError:(NSError *)error {
  PBRDebug(@"Error: %@", error);
  //[self showAlertWithTitle:@"Error" message:@"We had a problem"]; // TODO(gabe): Real error
  [[_searchService gh_proxyAfterDelay:2] search];
}

- (void)kegTimeHostEditViewController:(KegTimeHostEditViewController *)kegTimeHostEditViewController didAddHost:(KBKegTimeHost *)host {  
  [self addForm:[KBUIForm formWithTitle:host.name text:[NSString stringWithFormat:@"%@:%@", host.ipAddress, host.port] target:self action:@selector(_kegPadSelectHost:) context:host showDisclosure:YES] section:2];    
  [self reload];
  [self.navigationController popToViewController:self animated:YES];
}

@end

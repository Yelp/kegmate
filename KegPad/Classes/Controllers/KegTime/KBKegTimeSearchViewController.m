//
//  KBKegTimeSearchViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2010 Yelp. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "KBKegTimeSearchViewController.h"

#import "KBKegTimeViewController.h"
#import "FFUtils.h"
#import "KBApplication.h"
#import "FFStreamUtils.h"
#import "KBKegTimeHost.h"
#import "KBKegTimeHostInfoViewController.h"


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
    [self addForm:[KBUIForm formWithTitle:@"Info" text:nil target:self action:@selector(_showInfo) context:nil showDisclosure:YES] section:3];    
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
  _footerLabel.text = @"";
  if (!_searchService) {
    [self _refresh];
  }
}

- (void)close {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)_refresh {
  if (!_searchService) {
    _searchService = [[FFServiceBrowser alloc] initWithServiceType:@"_kegtime._tcp." domain:@"local."];
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
  //kegTimeViewController.videoSize = CGSizeMake(540, 720);
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
  KBKegTimeHostEditViewController *kegTimeHostEditViewController = [[KBKegTimeHostEditViewController alloc] init];
  kegTimeHostEditViewController.delegate = self;
  [self.navigationController pushViewController:kegTimeHostEditViewController animated:YES];
  [kegTimeHostEditViewController release];
}

- (void)_showInfo {
  KBKegTimeHostInfoViewController *kegTimeHostInfoViewController = [[KBKegTimeHostInfoViewController alloc] init];
  [self.navigationController pushViewController:kegTimeHostInfoViewController animated:YES];
  [kegTimeHostInfoViewController release];
}

- (void)searchService:(FFServiceBrowser *)searchService didFindAndResolveService:(NSNetService *)netService {
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

- (void)searchService:(FFServiceBrowser *)searchService didError:(NSError *)error {
  FFDebug(@"Error: %@", error);
  //[self showAlertWithTitle:@"Error" message:@"We had a problem"]; // TODO(gabe): Real error
  [[_searchService gh_proxyAfterDelay:2] search];
}

- (void)kegTimeHostEditViewController:(KBKegTimeHostEditViewController *)kegTimeHostEditViewController didAddHost:(KBKegTimeHost *)host {  
  [self addForm:[KBUIForm formWithTitle:host.name text:[NSString stringWithFormat:@"%@:%@", host.ipAddress, host.port] target:self action:@selector(_kegPadSelectHost:) context:host showDisclosure:YES] section:2];    
  [self reload];
  [self.navigationController popToViewController:self animated:YES];
}

@end

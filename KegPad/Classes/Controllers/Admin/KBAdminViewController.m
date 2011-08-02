//
//  KBAdminViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 7/29/10.
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

#import "KBAdminViewController.h"

#import "KBDataStore.h"
#import "KBApplication.h"
#import "KBDataImporter.h"
#import "KBUIForm.h"
#import "KBTwitterAdminViewController.h"
#import "KBSettingsViewController.h"
#import "KBRKKegsViewController.h"
#import "KBRKBrewersViewController.h"
#import "KBRKBeerStylesViewController.h"

@implementation KBAdminNavigationController

- (id)init {
  if ((self = [super init])) {
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    adminViewController_ = [[KBAdminViewController alloc] init];
    [self pushViewController:adminViewController_ animated:NO];
  }
  return self;
}

- (void)dealloc {
  [adminViewController_ release];
  [super dealloc];
}

@end

@implementation KBAdminViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = @"Admin";
    [self addForm:[KBUIForm formWithTitle:@"Beers" text:nil target:self action:@selector(showBeers) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Kegs" text:nil target:self action:@selector(showKegs) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Users" text:nil target:self action:@selector(showUsers) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Twitter" text:@"Connect to twitter." target:self action:@selector(showTwitterAdmin) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Settings" text:@"Settings like name and admin password." target:self action:@selector(showSettings) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Simulator" text:@"For testing." target:self action:@selector(showSimulator) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Update fixtures" text:@"Load fixture data (will reset changes from fixture data)." 
                                   target:self action:@selector(updateWithFixtures) showDisclosure:NO]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Admin";
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
}

- (void)close {
  [self dismissModalViewControllerAnimated:YES];
  [self.navigationController popToRootViewControllerAnimated:NO]; 
}

- (void)showBeers {
  KBRKBeerTypesViewController *beersViewController = [[KBRKBeerTypesViewController alloc] init];
  [beersViewController refresh];
  [self.navigationController pushViewController:beersViewController animated:YES];
  [beersViewController release];
}

- (void)showUsers {
  KBRKUsersViewController *usersViewController = [[KBRKUsersViewController alloc] init];
  [usersViewController refresh];
  [self.navigationController pushViewController:usersViewController animated:YES];
  [usersViewController release];
}

- (void)showKegs {
  KBRKKegsViewController *kegsViewController = [[KBRKKegsViewController alloc] init];
  [kegsViewController refresh];
  [self.navigationController pushViewController:kegsViewController animated:YES];
  [kegsViewController release];
}

- (void)showSimulator {  
  KBSimulatorViewController *simulatorViewController = [[KBSimulatorViewController alloc] init];
  simulatorViewController.delegate = self;
  [self.navigationController pushViewController:simulatorViewController animated:YES];
  [simulatorViewController release];
}

- (void)showTwitterAdmin {
  KBTwitterAdminViewController *twitterAdminViewController = [[KBTwitterAdminViewController alloc] init];
  [self.navigationController pushViewController:twitterAdminViewController animated:YES];
  [twitterAdminViewController release];
}

- (void)showSettings {
  KBSettingsViewController *settingsViewController = [[KBSettingsViewController alloc] init];
  [self.navigationController pushViewController:settingsViewController animated:YES];
  [settingsViewController release];
}

- (void)updateWithFixtures {
  // Manual importing of data; Temporary until we build out admin section
  [KBDataImporter updateDataStore:[KBApplication dataStore]];
}

#pragma mark KBUIFormViewControllerDelegate

- (void)formViewController:(KBUIFormViewController *)formViewController willSelectForm:(KBUIForm *)action {
  [self dismissModalViewControllerAnimated:NO];
  [self.navigationController popToRootViewControllerAnimated:NO];
}

@end

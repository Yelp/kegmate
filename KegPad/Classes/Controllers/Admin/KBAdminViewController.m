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

@implementation KBAdminViewController

- (id)init {
  if ((self = [super init])) {
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    adminOptionsController_ = [[KBAdminOptionsController alloc] init];
    [self pushViewController:adminOptionsController_ animated:NO];
  }
  return self;
}   

- (void)dealloc {
  [adminOptionsController_ release];
  [super dealloc];
}

@end

@implementation KBAdminOptionsController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = @"Admin";
    [self addForm:[KBUIForm formWithTitle:@"Beers" text:@"Show list of beers." target:self action:@selector(showBeers) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Kegs" text:@"Show keg list." target:self action:@selector(showKegs) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Users" text:@"Show users." target:self action:@selector(showUsers) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Simulator" text:@"For testing." target:self action:@selector(showSimulator) showDisclosure:YES]];
    [self addForm:[KBUIForm formWithTitle:@"Update fixtures" text:@"Load fixture data (will reset changes from fixture data)." 
                                   target:self action:@selector(updateWithFixtures) showDisclosure:NO]];
  }
  return self;
}

- (void)dealloc {
  [beersViewController_ release];
  [usersViewController_ release];
  [kegsViewController_ release];
  simulatorViewController_.delegate = nil;
  [simulatorViewController_ release];
  [super dealloc];
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
  if (!beersViewController_) 
    beersViewController_ = [[KBBeersViewController alloc] init];
  [self.navigationController pushViewController:beersViewController_ animated:YES];
}

- (void)showUsers {
  if (!usersViewController_) 
    usersViewController_ = [[KBUsersViewController alloc] init];
  [self.navigationController pushViewController:usersViewController_ animated:YES];
}

- (void)showKegs {
  if (!kegsViewController_) 
    kegsViewController_ = [[KBKegsViewController alloc] init];
  [self.navigationController pushViewController:kegsViewController_ animated:YES];
}

- (void)showSimulator {  
  if (!simulatorViewController_) {
    simulatorViewController_ = [[KBSimulatorViewController alloc] init];
    simulatorViewController_.delegate = self;
  }
  [self.navigationController pushViewController:simulatorViewController_ animated:YES];
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

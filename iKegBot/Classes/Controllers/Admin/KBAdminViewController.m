//
//  KBAdminViewController.m
//  KegBot
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
#import "KBKegBotApplication.h"
#import "KBDataImporter.h"
#import "KBUIAction.h"

@implementation KBAdminViewController

- (id)init {
  if ((self = [super init])) {
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
  if ((self = [super init])) {
    options_ = [[NSMutableArray alloc] initWithCapacity:10];
    [options_ addObject:[KBUIAction actionWithName:@"Beers" info:@"Show list of beers." target:self action:@selector(showBeers) showDisclosure:YES]];
    [options_ addObject:[KBUIAction actionWithName:@"Kegs" info:@"Show keg list." target:self action:@selector(showKegs) showDisclosure:YES]];
    [options_ addObject:[KBUIAction actionWithName:@"Users" info:@"Show users." target:self action:@selector(showUsers) showDisclosure:YES]];
    [options_ addObject:[KBUIAction actionWithName:@"Simulate imputs" info:@"For testing." target:self action:@selector(simulateInputs) showDisclosure:NO]];
  }
  return self;
}

- (void)dealloc {
  [beersViewController_ release];
  [usersViewController_ release];
  [kegsViewController_ release];
  [options_ release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Admin";
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)] autorelease];
}

- (void)close {
  [self dismissModalViewControllerAnimated:YES];
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


- (void)simulateInputs {  
  [[KBKegBotApplication kegProcessor] simulateInputs];
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  return [options_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  KBUIAction *action = [options_ objectAtIndex:indexPath.row];
  return [action tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBUIAction *action = [options_ objectAtIndex:indexPath.row];
  [action performAction];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

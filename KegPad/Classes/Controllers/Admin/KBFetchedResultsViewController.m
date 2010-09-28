//
//  KBFetchedResultsViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 8/9/10.
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

#import "KBFetchedResultsViewController.h"

@implementation KBFetchedResultsViewController

- (void)dealloc {
  [fetchedResultsController_ release];
  [super dealloc];
}

- (NSFetchedResultsController *)_fetchedResultsController {
  if (!fetchedResultsController_) {
    fetchedResultsController_ = [[self fetchedResultsController] retain];
  }
  return fetchedResultsController_;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSError *error = nil;
  if (![[self _fetchedResultsController] performFetch:&error]) {
    KBError(@"Error: %@", [error localizedFailureReason]);
  }
  [self.tableView reloadData];
}

- (NSFetchedResultsController *)fetchedResultsController { return nil; }

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj { return cell; }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[fetchedResultsController_ sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController_ sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"KBFetchedResultsController";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  
  cell.accessoryType = UITableViewCellAccessoryNone;
  id obj = [fetchedResultsController_ objectAtIndexPath:indexPath];
  return [self cell:cell forObject:obj];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
  id<NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController_ sections] objectAtIndex:section];
  return [sectionInfo name];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return [fetchedResultsController_ sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
  return [fetchedResultsController_ sectionForSectionIndexTitle:title atIndex:index];
}

@end

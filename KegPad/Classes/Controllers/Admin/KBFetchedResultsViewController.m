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
  fetchedResultsController_.delegate = nil;
  [fetchedResultsController_ release];
  [super dealloc];
}

- (NSFetchedResultsController *)fetchedResultsController {
  if (!fetchedResultsController_) {
    fetchedResultsController_ = [[self loadFetchedResultsController] retain];
    fetchedResultsController_.delegate = self;
  }
  return fetchedResultsController_;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  NSError *error = nil;
  if (![[self fetchedResultsController] performFetch:&error]) {
    KBError(@"Error: %@", [error localizedFailureReason]);
  }
  [self.tableView reloadData];
}

- (NSFetchedResultsController *)loadFetchedResultsController { 
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement fetchedResultsController"];
  return nil; 
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj { 
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement cell:forObject:"];
  return cell; 
}

- (void)deleteObject:(id)obj {
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement deleteObject:"];
}

- (void)insertAtIndexPath:(NSIndexPath *)indexPath {
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement insertAtIndexPath:"];
}

- (void)updateCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath { 
  // TODO(gabe): Implement
}

#pragma mark UITableViewDataSource

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

#pragma mark 

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {  
  switch(editingStyle) {
    case UITableViewCellEditingStyleInsert:
      [self insertAtIndexPath:indexPath];
      break;

    case UITableViewCellEditingStyleDelete: {
      id obj = [fetchedResultsController_ objectAtIndexPath:indexPath];
      [self deleteObject:obj];
      break;
    }
  }
}

#pragma mark NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}
 
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
 
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
 
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
    }
}
 
 
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
 
  UITableView *tableView = self.tableView;
 
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
 
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
 
    case NSFetchedResultsChangeUpdate:
      [self updateCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath]; 
      break;
 
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}
 
 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

@end

//
//  KBKegsViewController.m
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

#import "KBKegsViewController.h"
#import "KBDataStore.h"
#import "KBKeg.h"
#import "KBBeer.h"
#import "KBKegBotApplication.h"

@implementation KBKegsViewController

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Kegs";
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (void)_add {
  // TODO: Add form
}

- (NSFetchedResultsController *)fetchedResultsController {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBKeg" inManagedObjectContext:[[KBKegBotApplication dataStore] managedObjectContext]]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:[[KBKegBotApplication dataStore] managedObjectContext]
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:@"KBKegsViewController"];
  [fetchRequest release];
  return [fetchedResultsController autorelease];
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [NSString stringWithFormat:@"Keg: %@", [[obj beer] name]];
  cell.detailTextLabel.text = [[obj dateCreated] description];
  
  KBKeg *keg = [[KBKegBotApplication dataStore] kegAtPosition:0];
  if ([keg isEqual:obj]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBKeg *keg = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  [[KBKegBotApplication dataStore] setKeg:keg position:0];
  [self.tableView reloadData];
}

@end

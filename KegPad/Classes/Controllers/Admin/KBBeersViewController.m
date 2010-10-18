//
//  KBBeersViewController.m
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

#import "KBBeersViewController.h"
#import "KBDataStore.h"
#import "KBBeer.h"
#import "KBApplication.h"

@implementation KBBeersViewController

@synthesize delegate=delegate_;

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Beers";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (NSFetchedResultsController *)loadFetchedResultsController {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBBeer" inManagedObjectContext:[[KBApplication dataStore] managedObjectContext]]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];

  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:[[KBApplication dataStore] managedObjectContext]
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:@"KBBeersViewController"];
  [fetchRequest release];
  return [fetchedResultsController autorelease];
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [obj name];
  cell.detailTextLabel.text = [obj info];
  if (delegate_) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return cell;
}

- (void)_add {
  KBBeerEditViewController *beerEditViewController = [[KBBeerEditViewController alloc] init];
  beerEditViewController.delegate = self;
  [self.navigationController pushViewController:beerEditViewController animated:YES];
  [beerEditViewController release];
}

- (void)deleteObject:(id)obj {
  // TODO(gabe): Handle error
  [[[KBApplication dataStore] managedObjectContext] deleteObject:obj];
  [[[KBApplication dataStore] managedObjectContext] save:nil];  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBBeer *beer = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  if (delegate_) {
    [delegate_ beersViewController:self didSelectBeer:beer];
  } else {
    KBBeerEditViewController *beerEditViewController = [[KBBeerEditViewController alloc] init];
    beerEditViewController.delegate = self;
    [beerEditViewController setBeer:beer];
    [self.navigationController pushViewController:beerEditViewController animated:YES];
    [beerEditViewController release];
  }
}

#pragma mark KBBeerEditViewControllerDelegate

- (void)beerEditViewController:(KBBeerEditViewController *)beerEditViewController didSaveBeer:(KBBeer *)beer { 
  [self.navigationController popToViewController:self animated:YES];
}

@end

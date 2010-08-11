//
//  KBBeersViewController.m
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

#import "KBBeersViewController.h"
#import "KBDataStore.h"
#import "KBBeer.h"
#import "KBKegBotApplication.h"

@implementation KBBeersViewController

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Beers";
  }
  return self;
}

- (NSFetchedResultsController *)fetchedResultsController {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBBeer" inManagedObjectContext:[[KBKegBotApplication dataStore] managedObjectContext]]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];

  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                  managedObjectContext:[[KBKegBotApplication dataStore] managedObjectContext]
                                                                    sectionNameKeyPath:nil
                                                                             cacheName:@"KBBeersViewController"];
  [fetchRequest release];
  return [fetchedResultsController autorelease];
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [obj name];
  cell.detailTextLabel.text = [obj info];
  return cell;
}

@end

//
//  KBUsersViewController.m
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

#import "KBUsersViewController.h"

#import "KBApplication.h"
#import "KBUser.h"

@implementation KBUsersViewController

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Users";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (NSFetchedResultsController *)loadFetchedResultsController {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBUser" inManagedObjectContext:[[KBApplication dataStore] managedObjectContext]]];
  // TODO(gabe): Need to sort on fullName
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                             managedObjectContext:[[KBApplication dataStore] managedObjectContext]
                                                                                               sectionNameKeyPath:nil
                                                                                                        cacheName:@"KBUsersViewController"];
  [fetchRequest release];
  return [fetchedResultsController autorelease];
}

- (void)_add {
  KBUserEditViewController *userEditViewController = [[KBUserEditViewController alloc] init];
  userEditViewController.delegate = self;
  [self.navigationController pushViewController:userEditViewController animated:YES];
  [userEditViewController release];
}

- (void)deleteObject:(id)obj {
  // TODO(gabe): Handle error
  [[[KBApplication dataStore] managedObjectContext] deleteObject:obj];
  [[[KBApplication dataStore] managedObjectContext] save:nil];  
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [obj fullName];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Tag Id: %@, Volume poured: %@", [obj tagId], [obj pouredDescription]];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBUser *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];

  KBUserEditViewController *userEditViewController = [[KBUserEditViewController alloc] init];
  userEditViewController.delegate = self;
  [userEditViewController setUser:user];
  [self.navigationController pushViewController:userEditViewController animated:YES];
  [userEditViewController release];
}

#pragma mark KBUserEditViewControllerDelegate

- (void)userEditViewController:(KBUserEditViewController *)userEditViewController didAddUser:(KBUser *)user { 
  [self.navigationController popToViewController:self animated:YES];
}

@end

//
//  KBRKUsersViewController.m
//  KegPad
//
//  Created by John Boiles on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKUsersViewController.h"

@implementation KBRKUsersViewController

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Users";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (void)refresh {
  // Load the object model via RestKit	
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *userMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"user"];
  [objectManager loadObjectsAtResourcePath:@"/users" objectMapping:userMapping delegate:self];
}

- (void)_add {
  KBUserEditViewController *userEditViewController = [[KBUserEditViewController alloc] init];
  userEditViewController.delegate = self;
  [self.navigationController pushViewController:userEditViewController animated:YES];
  [userEditViewController release];
}

- (void)deleteObject:(id)obj {
  // TODO(gabe): Handle error
  //[[[KBApplication dataStore] managedObjectContext] deleteObject:obj];
  //[[[KBApplication dataStore] managedObjectContext] save:nil];  
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [obj fullName];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"Tag Id: %@, Volume poured: %@", [obj tagId], [obj pouredDescription]];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  /*
  KBUser *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
  
  KBUserEditViewController *userEditViewController = [[KBUserEditViewController alloc] init];
  userEditViewController.delegate = self;
  [userEditViewController setUser:user];
  [self.navigationController pushViewController:userEditViewController animated:YES];
  [userEditViewController release];
  */
}

#pragma mark KBUserEditViewControllerDelegate

- (void)userEditViewController:(KBUserEditViewController *)userEditViewController didSaveUser:(KBUser *)user { 
  [self.navigationController popToViewController:self animated:YES];
}


@end

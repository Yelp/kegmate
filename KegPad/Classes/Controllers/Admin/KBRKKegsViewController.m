//
//  KBRKKegsViewController.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKKegsViewController.h"
#import "KBRKKeg.h"

@implementation KBRKKegsViewController

- (void)loadKegs {
  // Load the object model via RestKit
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectLoader* loader = [objectManager loadObjectsAtResourcePath:@"/kegs" objectClass:[KBRKKeg class] delegate:self];
  loader.keyPath = @"result.kegs";
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  KBRKKeg *keg = (KBRKKeg *)obj;
  cell.textLabel.text = [NSString stringWithFormat:@"Keg: %@", [keg description]];
  //cell.detailTextLabel.text = [[obj dateCreated] description];
/*
  KBKeg *keg = [[KBApplication dataStore] kegAtPosition:0];
  if ([keg isEqual:obj]) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
 */
  return cell;
}

- (void)_add {
  KBKegEditViewController *kegEditViewController = [[KBKegEditViewController alloc] init];
  kegEditViewController.delegate = self;
  [self.navigationController pushViewController:kegEditViewController animated:YES];
  [kegEditViewController release];
}

- (void)deleteObject:(id)obj {
  // TODO(gabe): Handle error
  //[[[KBApplication dataStore] managedObjectContext] deleteObject:obj];
  //[[[KBApplication dataStore] managedObjectContext] save:nil];  
}

#pragma mark KBKegEditViewControllerDelegate

- (void)kegEditViewController:(KBKegEditViewController *)kegEditViewController didSaveKeg:(KBKeg *)keg {
  [self.navigationController popToViewController:self animated:YES];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBRKKeg *keg = [_objects objectAtIndex:indexPath.row];

  KBKegEditViewController *kegEditViewController = [[KBKegEditViewController alloc] initWithTitle:@"Keg" useEnabled:YES];
  kegEditViewController.delegate = self;
  [kegEditViewController setKeg:keg];
  [self.navigationController pushViewController:kegEditViewController animated:YES];
  [kegEditViewController release];
}

@end

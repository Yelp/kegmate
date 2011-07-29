//
//  KBKegsViewController.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKKegsViewController.h"
#import "KBRKKeg.h"

@implementation KBRKKegsViewController

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Kegs";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (void)refresh {
  // Load the object model via RestKit	
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *kegMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"keg"];
  [objectManager loadObjectsAtResourcePath:@"/kegs" objectMapping:kegMapping delegate:self];
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  KBRKKeg *keg = (KBRKKeg *)obj;
  cell.textLabel.text = [NSString stringWithFormat:@"Keg: %@", [keg descriptionText]];
  //cell.detailTextLabel.text = [[obj dateCreated] description];
/*
  // Check if this keg is the current keg
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
  KBRKKegEditViewController *kegEditViewController = [[KBRKKegEditViewController alloc] init];
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

- (void)kegEditViewController:(KBRKKegEditViewController *)kegEditViewController didSaveKeg:(KBRKKeg *)keg {
  [self.navigationController popToViewController:self animated:YES];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBRKKeg *keg = [self.objects objectAtIndex:indexPath.row];

  KBRKKegEditViewController *kegEditViewController = [[KBRKKegEditViewController alloc] initWithTitle:@"Keg" useEnabled:YES];
  kegEditViewController.delegate = self;
  [kegEditViewController setKeg:keg];
  [self.navigationController pushViewController:kegEditViewController animated:YES];
  [kegEditViewController release];
}

@end

//
//  KBRKBeerTypesViewController.m
//  KegPad
//
//  Created by John Boiles on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKBeerTypesViewController.h"

@implementation KBRKBeerTypesViewController

@synthesize delegate=delegate_;

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Beers";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (void)refresh {
  // Load the object model via RestKit
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *kegMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"beertype"];
  [objectManager loadObjectsAtResourcePath:@"/beer-types" objectMapping:kegMapping delegate:self];
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [obj name];
  //cell.detailTextLabel.text = [obj info];
  if (delegate_) {
    cell.accessoryType = UITableViewCellAccessoryNone;
  } else {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return cell;
}

- (void)_add {
  KBRKBeerTypeEditViewController *beerEditViewController = [[KBRKBeerTypeEditViewController alloc] init];
  //beerEditViewController.delegate = self;
  [self.navigationController pushViewController:beerEditViewController animated:YES];
  [beerEditViewController release];
}

- (void)deleteObject:(id)obj {
  // TODO(gabe): Handle error
  //[[[KBApplication dataStore] managedObjectContext] deleteObject:obj];
  //[[[KBApplication dataStore] managedObjectContext] save:nil];  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBRKBeerType *beerType = [_objects objectAtIndex:indexPath.row];
  if (delegate_) {
    [delegate_ beerTypesViewController:self didSelectBeerType:beerType];
  } else {
    KBRKBeerTypeEditViewController *beerTypeEditViewController = [[KBRKBeerTypeEditViewController alloc] init];
    beerTypeEditViewController.delegate = self;
    [beerTypeEditViewController setBeerType:beerType];
    [self.navigationController pushViewController:beerTypeEditViewController animated:YES];
    [beerTypeEditViewController release];
  }
}

#pragma mark KBRKBeerTypeEditViewControllerDelegate

- (void)beerEditViewController:(KBRKBeerTypeEditViewController *)beerEditViewController didSaveBeerType:(KBRKBeerType *)beerType {
  [self.navigationController popToViewController:self animated:YES];
}

@end

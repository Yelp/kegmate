//
//  KBRKBrewersViewController.m
//  KegPad
//
//  Created by John Boiles on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKBrewersViewController.h"
#import "KBRKBrewer.h"

@implementation KBRKBrewersViewController

@synthesize delegate=delegate_;

- (id)init {
  if ((self = [super init])) { 
    self.title = @"Brewers";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_add)] autorelease];
  }
  return self;
}

- (void)refresh {
  // Load the object model via RestKit
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *brewerMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"brewer"];
  [objectManager loadObjectsAtResourcePath:@"/brewers" objectMapping:brewerMapping delegate:self];
}

- (void)_add {
  /*
  KBBrewerEditViewController *brewerEditViewController = [[KBBrewerEditViewController alloc] init];
  brewerEditViewController.delegate = self;
  [self.navigationController pushViewController:brewerEditViewController animated:YES];
  [brewerEditViewController release];
   */
}

- (void)deleteObject:(id)obj {
  // TODO(gabe): Handle error
  //[[[KBApplication dataStore] managedObjectContext] deleteObject:obj];
  //[[[KBApplication dataStore] managedObjectContext] save:nil];  
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj {
  cell.textLabel.text = [obj name];
  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@", [obj originCity], [obj originState], [obj country]];
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBRKBrewer *brewer = [_objects objectAtIndex:indexPath.row];
  if (delegate_) {
    [delegate_ brewersViewController:self didSelectBrewer:brewer];
  } else {
    /*
    KBRKBrewerEditViewController *brewerEditViewController = [[KBRKBrewerEditViewController alloc] init];
    brewerEditViewController.delegate = self;
    [brewerEditViewController setBrewer:brewer];
    [self.navigationController pushViewController:brewerEditViewController animated:YES];
    [brewerEditViewController release];
     */
  }
}

#pragma mark KBRKBrewerEditViewControllerDelegate

/*
- (void)brewerEditViewController:(KBRKBrewerEditViewController *)brewerEditViewController didSaveBrewer:(KBRKBrewer *)brewer { 
  [self.navigationController popToViewController:self animated:YES];
}
*/

@end

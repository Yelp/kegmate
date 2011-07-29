//
//  KBRestKitViewController.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKViewController.h"
#import "KBRKKeg.h"

@implementation KBRKViewController

@synthesize objects=_objects;

- (id)init {
  self = [super init];
  return self;
}

#pragma mark Abstract

- (void)refresh {
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement refresh"];
}

- (UITableViewCell *)cell:(UITableViewCell *)cell forObject:(id)obj { 
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement cell:forObject:"];
  return cell; 
}

- (void)deleteObject:(id)obj {
  [NSException raise:NSDestinationInvalidException format:@"Subclasses must implement deleteObject:"];
}

#pragma mark RKObjectLoaderDelegate methods

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
  NSLog(@"Loaded payload: %@", [response bodyAsString]);
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  NSLog(@"Loaded objects: %@", objects);    
  [_objects release];
  _objects = [objects retain];
  [self.tableView reloadData];
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
  [alert show];
  NSLog(@"Hit error: %@", error);
}


#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  if (section == 0) return [_objects count];
  else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"KBRKViewController";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  
  cell.accessoryType = UITableViewCellAccessoryNone;
  id obj = [_objects objectAtIndex:indexPath.row];
  return [self cell:cell forObject:obj];
}
/*
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
*/
@end

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
  //XXX(johnb): Move this to the application delegate
  // Initialize RestKit
  RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://kegbot.net/sfo/api"];
  
  // Enable automatic network activity indicator management
  [RKRequestQueue sharedQueue].showsNetworkActivityIndicatorWhenBusy = YES;

  RKObjectMapper* mapper = objectManager.mapper;

  // Add our element to object mappings
  [mapper registerClass:[KBRKKeg class] forElementNamed:@"keg"];

  // Update date format so that we can parse twitter dates properly
  NSMutableArray* dateFormats = [[[mapper dateFormats] mutableCopy] autorelease];
  // Wed Sep 29 15:31:08 +0000 2010
  //[dateFormats addObject:@"E MMM d HH:mm:ss Z y"];
  // "2010-06-12T07:25:16Z", 
  [dateFormats addObject:@"y-MM-dTHH:mm:ssZ"];
  [mapper setDateFormats:dateFormats];
/*
  RKManagedObjectSeeder* seeder = [RKManagedObjectSeeder objectSeederWithObjectManager:objectManager];
  // Seed the database with instances of RKTStatus from a snapshot of the RestKit Twitter timeline
  [seeder seedObjectsFromFile:@"rk_kegs.json" toClass:[KBRKKeg class] keyPath:@"result.kegs"];
  
  // Finalize the seeding operation and output a helpful informational message
  [seeder finalizeSeedingAndExit];
*/
  // Initialize object store
  objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"RKKegPad.sqlite" usingSeedDatabaseName:RKDefaultSeedDatabaseFileName managedObjectModel:nil];

  return self;
}

#pragma mark Abstract

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
  NSLog(@"Loaded statuses: %@", objects);    
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

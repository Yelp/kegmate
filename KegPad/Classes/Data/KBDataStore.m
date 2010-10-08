//
//  KBDataStore.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/10.
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

#import "KBDataStore.h"

#import "KBNotifications.h"
#import "KBBeer.h"
#import "KBKeg.h"
#import "KBKegPour.h"
#import "KBKegTemperature.h"
#import "KBRating.h"


@implementation KBDataStore

- (void)dealloc {  
  [managedObjectContext_ release];
  [managedObjectModel_ release];
  [persistentStoreCoordinator_ release];
  [super dealloc];
}

- (NSManagedObjectContext *)managedObjectContext {
  if (managedObjectContext_) return managedObjectContext_;

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    managedObjectContext_ = [[NSManagedObjectContext alloc] init];
    [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
  }
  return managedObjectContext_;
}

- (NSManagedObjectModel *)managedObjectModel {  
  if (managedObjectModel_) return managedObjectModel_;
  NSString *modelPath = [[NSBundle mainBundle] pathForResource:@"KegPad" ofType:@"momd"];
  NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
  managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
  return managedObjectModel_;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  
  if (persistentStoreCoordinator_) return persistentStoreCoordinator_;
  
  NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"KegPad.sqlite"];
  KBDebug(@"Path: %@", path);
  NSURL *storeURL = [NSURL fileURLWithPath:path];
  
  NSError *error = nil;
  persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  
  // Auto-update
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:                          
                           [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,                          
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_3_0
                           [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
#endif
                           nil];
  
  if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    KBError(@"Error: %@", [error localizedFailureReason]);
  }    
  
  return persistentStoreCoordinator_;
}

- (NSString *)applicationDocumentsDirectory {
  KBDebug(@"Documents directories: %@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) gh_firstObject];
}

- (NSArray *)executeFetchRequest:(NSFetchRequest *)request error:(NSError **)error {
  if (!error) {
    NSError *tmpError = nil;
    error = &tmpError;
  }
  NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:error];
  
  if (error && *error) {
    KBError(@"Error fetching: %@", [*error localizedDescription]);
  }
  return results;
}

- (BOOL)save:(NSError **)error {
  if (!error) {
    NSError *tmpError = nil;
    error = &tmpError;
  }
  
  BOOL saved = [[self managedObjectContext] save:error];
  
  if (error && *error) {
    KBError(@"Error saving: %@", [*error localizedDescription]);
  }
  return saved;
}

- (id)objectForURI:(NSString *)URIString {
  if (!URIString) return nil;
  NSManagedObjectID *objectId = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:URIString]];
  if (!objectId) return nil;
  return [[self managedObjectContext] objectWithID:objectId];
}

- (void)setKeg:(KBKeg *)keg position:(NSInteger)position {
  KBDebug(@"Saving keg: %@", keg);
  if (!keg) return;
  keg.indexValue = position;
  NSString *URIString = [[[keg objectID] URIRepresentation] absoluteString];
  [[NSUserDefaults standardUserDefaults] setObject:URIString forKey:[NSString stringWithFormat:@"KBSelectedKegObjectIds-%d", keg.indexValue]];
  [[NSUserDefaults standardUserDefaults] synchronize];  
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegSelectionDidChangeNotification object:keg];
}

- (KBKeg *)kegAtPosition:(NSInteger)position {
  NSString *key = [NSString stringWithFormat:@"KBSelectedKegObjectIds-%d", position];
  return [self objectForURI:[[NSUserDefaults standardUserDefaults] objectForKey:key]];
}

- (KBBeer *)beerWithId:(NSString *)id error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBBeer" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id = %@", id]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  return [results gh_firstObject];
}

- (NSArray *)kegsWithOffset:(NSUInteger)offset limit:(NSUInteger)limit error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setFetchOffset:offset];
  [fetchRequest setFetchLimit:limit];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBKeg" inManagedObjectContext:[self managedObjectContext]]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dateCreated" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];  
  return [self executeFetchRequest:fetchRequest error:error];
}

- (BOOL)addKegWithBeer:(KBBeer *)beer error:(NSError **)error {
  KBKeg *keg = [NSEntityDescription insertNewObjectForEntityForName:@"KBKeg" inManagedObjectContext:[self managedObjectContext]];
  keg.id = [NSString gh_uuid];
  keg.beer = beer;
  keg.dateCreated = [NSDate date];
  keg.volumeTotalValue = 58.67;
  return [self save:error];  
}

- (KBKeg *)kegWithId:(NSString *)id error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBKeg" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id = %@", id]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  return [results gh_firstObject];
}

- (KBKeg *)addOrUpdateKegWithId:(NSString *)id beer:(KBBeer *)beer volumeAdjusted:(float)volumeAdjusted volumeTotal:(float)volumeTotal error:(NSError **)error {  
  KBKeg *keg = [self kegWithId:id error:error];
  if (!keg) {
    keg = [NSEntityDescription insertNewObjectForEntityForName:@"KBKeg" inManagedObjectContext:[self managedObjectContext]];
    keg.id = id;
    keg.dateCreated = [NSDate date];
  }
  keg.beer = beer;
  keg.volumeAdjustedValue = volumeAdjusted;
  keg.volumeTotalValue = volumeTotal;
  BOOL saved = [self save:error];  
  if (!saved) return nil;
  return keg;
}

- (KBBeer *)addOrUpdateBeerWithId:(NSString *)id name:(NSString *)name info:(NSString *)info type:(NSString *)type country:(NSString *)country 
imageName:(NSString *)imageName abv:(float)abv error:(NSError **)error {  
  KBBeer *beer = [self beerWithId:id error:error];
  if (!beer) {
    beer = [NSEntityDescription insertNewObjectForEntityForName:@"KBBeer" inManagedObjectContext:[self managedObjectContext]];
    beer.id = id;
  }
  beer.name = name;
  beer.type = type;
  beer.country = country;
  beer.info = info;
  beer.imageName = imageName;
  beer.abvValue = abv;
  BOOL saved = [self save:error];
  if (!saved) return nil;
  return beer;
}

- (BOOL)addKegTemperature:(float)temperature keg:(KBKeg *)keg error:(NSError **)error {
  if (!keg) return NO;
  KBKegTemperature *kegTemperature = [NSEntityDescription insertNewObjectForEntityForName:@"KBKegTemperature" inManagedObjectContext:[self managedObjectContext]];
  kegTemperature.keg = keg;
  kegTemperature.date = [NSDate date];
  kegTemperature.temperatureValue = temperature;
  BOOL saved = [self save:error];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegTemperatureDidChangeNotification object:kegTemperature];
  return saved;
}

- (BOOL)addKegPour:(float)amount keg:(KBKeg *)keg user:(KBUser *)user error:(NSError **)error {
  if (!keg) return NO;
  KBKegPour *kegPour = [NSEntityDescription insertNewObjectForEntityForName:@"KBKegPour" inManagedObjectContext:[self managedObjectContext]];
  kegPour.keg = keg;
  kegPour.date = [NSDate date];
  kegPour.user = user;
  kegPour.amountValue = amount;
  
  [keg addPouredValue:amount];
  
  [kegPour.user addPouredValue:amount];
  
  kegPour.amountHourValue = [self rateForKegPoursLastHourForUser:nil error:error];
  kegPour.amountUserHourValue = [self rateForKegPoursLastHourForUser:kegPour.user error:error];
  
  BOOL saved = [self save:error];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegVolumeDidChangeNotification object:keg];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidSavePourNotification object:kegPour];
  return saved;
}

- (NSArray */*of KBKegPour*/)recentKegPours:(NSUInteger)limit ascending:(BOOL)ascending error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBKegPour" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setFetchLimit:limit];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:ascending];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  return [self executeFetchRequest:fetchRequest error:error];
}

- (NSArray *)usersWithOffset:(NSUInteger)offset limit:(NSUInteger)limit error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setFetchOffset:offset];
  [fetchRequest setFetchLimit:limit];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBUser" inManagedObjectContext:[self managedObjectContext]]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  return [self executeFetchRequest:fetchRequest error:error];
}

- (NSArray */*of KBKegPour*/)recentKegPoursFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate user:(KBUser *)user error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBKegPour" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"date >= %@ AND date <= %@", fromDate, toDate]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  return [self executeFetchRequest:fetchRequest error:error];
}

- (float)rateForKegPoursLastHourForUser:(KBUser *)user error:(NSError **)error {
  NSArray *kegPours = [self recentKegPoursFromDate:[NSDate dateWithTimeIntervalSinceNow:-(60 * 60)] toDate:[NSDate date] user:user error:error];
  KBDebug(@"Loaded %d keg pours from last hour", [kegPours count]);
  CGFloat value = 0;
  NSTimeInterval start = 0, end = 0;
  for (KBKegPour *pour in kegPours) {
    if (end == 0) end = [[pour date] timeIntervalSince1970];
    start = [[pour date] timeIntervalSince1970];
    value += pour.amountValue;
  }
  NSTimeInterval interval = fabs(end - start);
  return (interval > 0 ? (value / interval) : 0);
}

// TODO(gabe): This is inefficient
- (BOOL)updateKegStatsFromRecentPours:(KBUser *)user limit:(NSUInteger)limit error:(NSError **)error {
  NSArray *kegPours = [self recentKegPours:limit ascending:NO error:nil];  
  for (KBKegPour *pour in kegPours)
    pour.amountHourValue = [self rateForKegPoursLastHourForUser:user error:error];
  return [self save:error];
}

- (KBKegPour *)lastPour:(NSError **)error {
  return [[self recentKegPours:1 ascending:NO error:error] gh_firstObject];
}

- (KBRating *)ratingWithUser:(KBUser *)user beer:(KBBeer *)beer error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBRating" inManagedObjectContext:[self managedObjectContext]]];
  KBDebug(@"Fetching with user: %@, beer: %@", user.firstName, beer.name);
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user = %@ and beer = %@", user, beer]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  return [results gh_firstObject];  
}

- (KBRating *)setRating:(KBRatingValue)ratingValue user:(KBUser *)user beer:(KBBeer *)beer error:(NSError **)error {
  KBRating *rating = [self ratingWithUser:user beer:beer error:error];
  if (!rating) {
    KBDebug(@"Creating rating with user: %@, beer: %@", user.firstName, beer.name);
    rating = [NSEntityDescription insertNewObjectForEntityForName:@"KBRating" inManagedObjectContext:[self managedObjectContext]];
    rating.user = user;
    rating.beer = beer;
  }
  rating.ratingValue = ratingValue;
  BOOL saved = [self save:error];
  if (!saved) return nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidSetRatingNotification object:rating];
  return rating;  
}

- (KBUser *)addOrUpdateUserWithTagId:(NSString *)tagId firstName:(NSString *)firstName lastName:(NSString *)lastName error:(NSError **)error {
  KBUser *user = [self userWithTagId:tagId error:error];
  if (!user)
    user = [NSEntityDescription insertNewObjectForEntityForName:@"KBUser" inManagedObjectContext:[self managedObjectContext]];
  user.firstName = firstName;
  user.lastName = lastName;
  user.tagId = tagId;
  BOOL saved = [self save:error];
  if (!saved) return nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidAddUserNotification object:user];
  return user;
}

- (KBUser *)userWithTagId:(NSString *)tagId error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBUser" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setFetchLimit:1];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tagId = %@", tagId]];
  return [[self executeFetchRequest:fetchRequest error:error] gh_firstObject];
}

- (NSArray *)topUsersByPourWithOffset:(NSUInteger)offset limit:(NSUInteger)limit error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBUser" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setFetchLimit:limit];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"volumePoured" ascending:NO];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  
  return [self executeFetchRequest:fetchRequest error:error];  
}

- (void)recomputeStats {
  [self updateKegStatsFromRecentPours:nil limit:1000 error:nil];
  for (KBUser *user in [self usersWithOffset:0 limit:1000 error:nil]) {
    [self updateKegStatsFromRecentPours:user limit:1000 error:nil];
  }
}

@end

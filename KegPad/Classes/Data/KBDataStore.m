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
#import "KBPourIndex.h"


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

- (id)insertNewObjectForEntityForName:(NSString *)entityName inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
  if (!managedObjectContext) {    
    NSManagedObjectModel *managedObjectModel = [self managedObjectModel];
    NSEntityDescription *entity = [[managedObjectModel entitiesByName] objectForKey:entityName];
    return [[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:nil] autorelease];
  } else {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
  }
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
  if ([NSString gh_isBlank:id]) return nil;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBBeer" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id = %@", id]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return [results gh_firstObject];
}

- (NSArray */*of KBBeer*/)beersWithOffset:(NSUInteger)offset limit:(NSUInteger)limit error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setFetchOffset:offset];
  [fetchRequest setFetchLimit:limit];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBBeer" inManagedObjectContext:[self managedObjectContext]]];
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [fetchRequest setSortDescriptors:sortDescriptors];
  [sortDescriptors release];
  [sortDescriptor release];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;
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
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;
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
  [fetchRequest release];
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

- (KBKegTemperature *)addKegTemperature:(float)temperature keg:(KBKeg *)keg error:(NSError **)error {
  if (!keg) return NO;
  KBKegTemperature *kegTemperature = [KBKegTemperature kegTemperature:temperature keg:keg date:[NSDate date] inManagedObjectContext:[self managedObjectContext]];
  BOOL saved = [self save:error];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegTemperatureDidChangeNotification object:kegTemperature];
  if (saved) return kegTemperature;
  return nil;
}

+ (NSInteger)timeIndexForForDate:(NSDate *)date timeType:(KBPourIndexTimeType)timeType {
  switch (timeType) {
    case KBPourIndexTimeTypeHour: {
      return ceilf([date timeIntervalSinceReferenceDate] / (double)(60.0 * 60.0));
    }
    case KBPourIndexTimeTypeMinutes15: {
      return ceilf([date timeIntervalSinceReferenceDate] / (double)(60.0 * 60.0 * 0.25));
    }
  }
  return -1;
}

- (KBPourIndex *)pourIndexForDate:(NSDate *)date timeType:(KBPourIndexTimeType)timeType keg:(KBKeg *)keg user:(KBUser *)user error:(NSError **)error {
  NSInteger timeIndex = [KBDataStore timeIndexForForDate:date timeType:timeType];
  if (timeIndex < 0) return nil;
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBPourIndex" inManagedObjectContext:[self managedObjectContext]]];
  // TODO(gabe): Deal with optional user and keg
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timeType = %@ AND timeIndex = %@", 
                              [NSNumber numberWithInteger:timeType], [NSNumber numberWithInteger:timeIndex], keg]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return [results gh_firstObject];
}

- (KBPourIndex *)updatePourIndex:(float)amount date:(NSDate *)date timeType:(KBPourIndexTimeType)timeType keg:(KBKeg *)keg user:(KBUser *)user error:(NSError **)error {
  KBPourIndex *pourIndex = [self pourIndexForDate:date timeType:timeType keg:keg user:user error:error];
  if (!pourIndex) {
    pourIndex = [NSEntityDescription insertNewObjectForEntityForName:@"KBPourIndex" inManagedObjectContext:[self managedObjectContext]];
    pourIndex.keg = keg;
    pourIndex.user = user;
    pourIndex.timeTypeValue = timeType;
    NSInteger timeIndex = [KBDataStore timeIndexForForDate:date timeType:timeType];
    pourIndex.timeIndexValue = timeIndex;
  }

  pourIndex.volumePouredValue += amount;
  pourIndex.pourCountValue += 1;
  KBDebug(@"Updated pour index: %@", pourIndex);
  return pourIndex;
}

- (NSArray */*of KBPourIndex*/)pourIndexesForStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex timeType:(KBPourIndexTimeType)timeType 
                                                    keg:(KBKeg *)keg user:(KBUser *)user error:(NSError **)error {

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBPourIndex" inManagedObjectContext:[self managedObjectContext]]];
  // TODO(gabe): Deal with optional user and keg
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"timeType = %@ AND timeIndex >= %@ AND timeIndex <= %@", 
                              [NSNumber numberWithInteger:timeType], [NSNumber numberWithInteger:startIndex], [NSNumber numberWithInteger:endIndex]]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;
}

- (BOOL)addKegPour:(float)amount keg:(KBKeg *)keg user:(KBUser *)user date:(NSDate *)date error:(NSError **)error {
  if (!keg) return NO;
  KBKegPour *kegPour = [NSEntityDescription insertNewObjectForEntityForName:@"KBKegPour" inManagedObjectContext:[self managedObjectContext]];
  kegPour.keg = keg;
  kegPour.date = date;
  kegPour.user = user;
  kegPour.amountValue = amount;
  
  [keg addPouredValue:amount];
  
  [user addPouredValue:amount];
  
  [self updatePourIndex:amount date:date timeType:KBPourIndexTimeTypeMinutes15 keg:keg user:user error:error];
  
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
  
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;
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
  
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;  
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
  
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;  
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

- (KBKegPour *)lastPour:(NSError **)error {
  return [[self recentKegPours:1 ascending:NO error:error] gh_firstObject];
}

- (KBRating *)ratingWithUser:(KBUser *)user beer:(KBBeer *)beer error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBRating" inManagedObjectContext:[self managedObjectContext]]];
  KBDebug(@"Fetching with user: %@, beer: %@", user.firstName, beer.name);
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user = %@ and beer = %@", user, beer]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return [results gh_firstObject];  
}

- (KBRating *)setRating:(KBRatingValue)ratingValue user:(KBUser *)user keg:(KBKeg *)keg error:(NSError **)error {
  KBRating *rating = [self ratingWithUser:user beer:keg.beer error:error];
  if (!rating) {
    KBDebug(@"Creating rating with user: %@, beer: %@", user.firstName, keg.beer.name);
    rating = [NSEntityDescription insertNewObjectForEntityForName:@"KBRating" inManagedObjectContext:[self managedObjectContext]];
    rating.user = user;
    rating.beer = keg.beer;
    
    keg.ratingTotalValue += ratingValue;
    keg.ratingCountValue += 1;
    // TODO(gabe): Set rating for beer in KBKeg
    keg.beer.ratingTotalValue += ratingValue;
    keg.beer.ratingCountValue += 1;    
  } else {
    // Update total by subtracting existing and adding new value
    keg.ratingTotalValue -= rating.ratingValue;
    keg.ratingTotalValue += ratingValue;
    // TODO(gabe): Set rating for beer in KBKeg
    keg.beer.ratingTotalValue -= rating.ratingValue;
    keg.beer.ratingTotalValue += ratingValue;    
  }
  rating.ratingValue = ratingValue;
  BOOL saved = [self save:error];
  if (!saved) return nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidSetRatingNotification object:rating];
  return rating;  
}

- (KBUser *)addOrUpdateUserWithTagId:(NSString *)tagId firstName:(NSString *)firstName lastName:(NSString *)lastName 
                             isAdmin:(BOOL)isAdmin error:(NSError **)error {
  KBUser *user = [self userWithTagId:tagId error:error];
  if (!user)
    user = [NSEntityDescription insertNewObjectForEntityForName:@"KBUser" inManagedObjectContext:[self managedObjectContext]];
  user.firstName = firstName;
  user.lastName = lastName;
  user.tagId = tagId;
  user.isAdminValue = isAdmin;
  BOOL saved = [self save:error];
  if (!saved) return nil;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidUpdateUserNotification object:user];
  return user;
}

- (KBUser *)userWithTagId:(NSString *)tagId error:(NSError **)error {
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"KBUser" inManagedObjectContext:[self managedObjectContext]]];
  [fetchRequest setFetchLimit:1];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"tagId = %@", tagId]];
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return [results gh_firstObject];  
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
  
  NSArray *results = [self executeFetchRequest:fetchRequest error:error];
  [fetchRequest release];
  return results;
}

@end

//
//  KBDataImporter.m
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

#import "KBDataImporter.h"

#import "KBApplication.h"

#import <YAJLIOS/YAJLIOS.h>

@implementation KBDataImporter

- (void)updateUsersInDataStore:(KBDataStore *)dataStore {
  NSError *error = nil;
  NSArray *users = [[NSBundle mainBundle] yajl_JSONFromResource:@"users.json"];
  for (NSDictionary *user in users) {
    [dataStore addOrUpdateUserWithTagId:[user gh_objectMaybeNilForKey:@"tag_id"]
                              firstName:[user gh_objectMaybeNilForKey:@"first_name"]
                               lastName:[user gh_objectMaybeNilForKey:@"last_name"]
                                 error:&error];
    KBDataStoreCheckError(error);
  }
}

- (void)updateBeersInDataStore:(KBDataStore *)dataStore {
  NSError *error = nil;
  NSArray *beers = [[NSBundle mainBundle] yajl_JSONFromResource:@"beers.json"];
  for (NSDictionary *beer in beers) {
    [dataStore addOrUpdateBeerWithId:[beer gh_objectMaybeNilForKey:@"id"]
                                name:[beer gh_objectMaybeNilForKey:@"name"]
                                info:[beer gh_objectMaybeNilForKey:@"info"]
                                type:[beer gh_objectMaybeNilForKey:@"type"]
                              country:[beer gh_objectMaybeNilForKey:@"country"]
                            imageName:[beer gh_objectMaybeNilForKey:@"image"]
                                  abv:[[beer gh_objectMaybeNilForKey:@"abv"] floatValue]
                                error:&error];
    KBDataStoreCheckError(error);
  }
}

- (void)updateKegsInDataStore:(KBDataStore *)dataStore {
  NSError *error = nil;
  NSArray *kegs = [[NSBundle mainBundle] yajl_JSONFromResource:@"kegs.json"];
  KBDebug(@"kegs=%@", kegs);
  for (NSDictionary *keg in kegs) {
    NSString *beerId = [keg gh_objectMaybeNilForKey:@"beer_id"];
    KBBeer *beer = [dataStore beerWithId:beerId error:nil];
    NSAssert1(beer, @"Beer with id: \"%@\" not found", beerId);
    [dataStore addOrUpdateKegWithId:[keg gh_objectMaybeNilForKey:@"id"]
                               beer:beer
                     volumeAdjusted:[[keg gh_objectMaybeNilForKey:@"volume_adjusted"] floatValue]
                        volumeTotal:[[keg gh_objectMaybeNilForKey:@"volume_total"] floatValue]
                              error:&error];
    KBDataStoreCheckError(error);
  }
}

+ (void)updateDataStore:(KBDataStore *)dataStore {
  NSParameterAssert(dataStore);
  KBDataImporter *importer = [[KBDataImporter alloc] init];
  [importer updateUsersInDataStore:dataStore];
  [importer updateBeersInDataStore:dataStore];
  [importer updateKegsInDataStore:dataStore];
  
  // If we don't have a selected keg then lets select the first one
  if (![dataStore kegAtPosition:0]) {
    NSError *error = nil;
    KBKeg *keg = [[dataStore kegsWithOffset:0 limit:1 error:&error] gh_firstObject];
    KBDataStoreCheckError(error);
    NSAssert(keg, @"No keg could be selected");
    [dataStore setKeg:keg position:0];
    KBDebug(@"Auto selecting keg: %@", keg);
  }
  
  [importer release];
}
 
@end

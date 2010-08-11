//
//  KBKegProcessor.m
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

#import "KBKegProcessor.h"

#import "KBNotifications.h"
#import "KBApplication.h"

@implementation KBKegProcessor

@synthesize currentUser=currentUser_, dataStore=dataStore_;

- (id)init {
  if ((self = [super init])) {
    dataStore_ = [[KBDataStore alloc] init];
  }
  return self;
}

- (void)dealloc {
  processing_.delegate = nil;
  [processing_ release];
  [dataStore_ release];
  [currentUser_ release];
  [currentUserDate_ release];
  [super dealloc];
}

- (void)start {
  if (!processing_) {
    processing_ = [[KBKegProcessing alloc] init];
    processing_.delegate = self;
  }
}

- (void)setCurrentUser:(KBUser *)currentUser {
  [currentUser retain];
  [currentUser_ release];
  currentUser_ = currentUser;
  [currentUserDate_ release];
  currentUserDate_ = nil;
  if (currentUser_) {
    currentUserDate_ = [[NSDate date] retain];
  }
}

- (KBUser *)_currentUser {
  if (pouring_) return currentUser_;
  if (!currentUserDate_) return nil;
  if (fabs([currentUserDate_ timeIntervalSinceNow]) > 10) return nil; // Max login time idle
  return currentUser_;
}

- (KBUser *)currentUser {
  KBUser *currentUser = [self _currentUser];
  return currentUser;
}

#pragma mark KBKegProcessingDelegate

- (void)kegProcessingDidStartPour:(KBKegProcessing *)kegProcessing {
  pouring_ = YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidStartPourNotification object:nil];
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didEndPourWithAmount:(double)amount {
  
  if (amount > 0) 
    [dataStore_ addKegPour:amount keg:[dataStore_ kegAtPosition:0] user:[self currentUser] error:nil];
  
  pouring_ = NO;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidEndPourNotification object:nil];

  // Clear user!
  self.currentUser = nil;
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didChangeTemperature:(double)temperature {
  [dataStore_ addKegTemperature:temperature keg:[dataStore_ kegAtPosition:0] error:nil];
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didReceiveRFIDTagId:(NSString *)tagId {
  // TODO(johnb): tagId is coming in with some giberish
  tagId = [tagId gh_strip];
  self.currentUser = (tagId ? [dataStore_ userWithRFID:tagId error:nil] : nil);
  [[KBApplication sharedDelegate] playSystemSoundGlass];
  NSLog(@"RFID=%@, currentUser=%@", tagId, self.currentUser);
}

#pragma mark Testing

- (void)simulateInputs {
  KBKeg *keg = [dataStore_ kegAtPosition:0];
  NSLog(@"Keg: %@", keg);
  KBUser *user = [dataStore_ userWithRFID:@"29009401239F" error:nil];
  NSLog(@"User: %@", user);
  srand(time(NULL));
  // Randomly select this user or leave anonymous
  if (rand() % 2 == 0) [self setCurrentUser:user];
  // Simulate temperature reading
  [[self gh_proxyAfterDelay:1] kegProcessing:nil didChangeTemperature:10.4];
  // Simulate start and end pour with random amount
  [[self gh_proxyAfterDelay:2] kegProcessingDidStartPour:nil];
  [[self gh_proxyAfterDelay:12] kegProcessing:nil didEndPourWithAmount:(0.2 + (rand() / (double)RAND_MAX))];   
}

@end

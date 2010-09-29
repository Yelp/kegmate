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

@interface KBKegProcessor ()
@property (retain, nonatomic) KBUser *loginUser;
@property (retain, nonatomic) NSDate *loginDate;

/*!
 Logout.
 @param postNotification If YES, will post log out notification.
 */
- (void)_logout:(BOOL)postNotification;
@end

static const NSTimeInterval kLoggedInTimeoutInterval = 10.0;

@implementation KBKegProcessor

@synthesize dataStore=dataStore_, loginUser=loginUser_, processing=processing_;
@synthesize loginDate=loginDate_; // Private properties

- (id)init {
  if ((self = [super init])) {
    dataStore_ = [[KBDataStore alloc] init];
  }
  return self;
}

- (void)dealloc {
  [loginTimer_ invalidate];
  processing_.delegate = nil;
  [processing_ release];
  [dataStore_ release];
  [loginUser_ release];
  [loginDate_ release];
  [super dealloc];
}

- (void)start {
  if (!processing_) {
    processing_ = [[KBKegProcessing alloc] init];
    processing_.delegate = self;
  }
}

- (void)login:(KBUser *)user {
  NSParameterAssert(user);
  // Check if its the same user, so we don't log out and log in the same user,
  // though we will re-set the login date and timer below even if they are equal.
  if (!(self.loginUser && [self.loginUser isEqual:user])) {
    [self _logout:NO];
    self.loginUser = user;
  }
  
  // Set login date and timer if logged in
  self.loginDate = [NSDate date];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidLoginNotification object:self.loginUser];
  loginTimer_ = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_checkLoginStatus) userInfo:nil repeats:YES];
}

- (void)_logout:(BOOL)postNotification {
  KBUser *previousUser = [self.loginUser retain];
  self.loginDate = nil;
  self.loginUser = nil;
  [loginTimer_ invalidate];
  loginTimer_ = nil;  
  if (previousUser && postNotification) {
    [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidLogoutNotification object:previousUser];
  }
}

- (void)logout {
  [self _logout:YES];
}

//! Run from timer after login, and logout if timeout was reached
- (void)_checkLoginStatus {
  if (pouring_) return; // Don't log out current user if pouring
  if (!loginDate_) return;
  
  if (fabs([loginDate_ timeIntervalSinceNow]) > kLoggedInTimeoutInterval) {
    [self logout];
  }
}

#pragma mark KBKegProcessingDelegate

- (void)kegProcessingDidStartPour:(KBKegProcessing *)kegProcessing {
  pouring_ = YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidStartPourNotification object:nil];
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didEndPourWithAmount:(double)amount {
  
  if (amount > 0) 
    [dataStore_ addKegPour:amount keg:[dataStore_ kegAtPosition:0] user:self.loginUser error:nil];
  
  pouring_ = NO;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidEndPourNotification object:nil];

  [self logout]; // Done with pour, logout user
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didChangeTemperature:(double)temperature {
  [dataStore_ addKegTemperature:temperature keg:[dataStore_ kegAtPosition:0] error:nil];
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didReceiveRFIDTagId:(NSString *)tagId {
  // TODO(johnb): tagId is coming in with some giberish
  tagId = [tagId gh_strip];
  
  if ([tagId gh_isBlank]) return;
  
  KBUser *user = (tagId ? [dataStore_ userWithTagId:tagId error:nil] : nil);
  if (user) {
    [self login:user];
    [[KBApplication sharedDelegate] playSystemSoundGlass];
    KBDebug(@"RFID=%@, user=%@", tagId, user);
  } else {
    [self logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:KBUnknownTagIdNotification object:tagId];    
  }
}

@end

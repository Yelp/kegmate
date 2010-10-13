//
//  KBKegManager.m
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

#import "KBKegManager.h"

#import "KBNotifications.h"
#import "KBApplication.h"

@interface KBKegManager ()
@property (retain, nonatomic) KBUser *loginUser;
@property (assign, nonatomic) NSTimeInterval activityTime;

/*!
 Logout.
 @param postNotification If YES, will post log out notification.
 */
- (void)_logout:(BOOL)postNotification;
@end


static const NSTimeInterval kLoggedInTimeoutInterval = 10.0;
static const NSTimeInterval kLoggedInTimeoutAfterPourInterval = 3.0; // Logs out this many seconds after pour


@implementation KBKegManager

@synthesize dataStore=dataStore_, loginUser=loginUser_, processing=processing_;
@synthesize activityTime=activityTime_; // Private properties

- (id)init {
  if ((self = [super init])) {
    dataStore_ = [[KBDataStore alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_activityNotification:) name:KBActivityNotification object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [loginTimer_ invalidate];
  processing_.delegate = nil;
  [processing_ release];
  [dataStore_ release];
  [loginUser_ release];
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
  
  // Set activity time and timer if logged in
  self.activityTime = [NSDate timeIntervalSinceReferenceDate];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidLoginNotification object:self.loginUser];
  loginTimer_ = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_checkLoginStatus) userInfo:nil repeats:YES];
}

- (void)_logout:(BOOL)postNotification {
  KBUser *previousUser = [self.loginUser retain];
  self.activityTime = 0;
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
  
  if ([NSDate timeIntervalSinceReferenceDate] - activityTime_ > kLoggedInTimeoutInterval) {
    [self logout];
  }
}

#pragma mark Notifications

- (void)_activityNotification:(NSNotification *)Notifications {
  self.activityTime = [NSDate timeIntervalSinceReferenceDate];
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

  // Set timer to timeout in kLoggedInTimeoutAfterPourInterval seconds after a pour
  self.activityTime = ([NSDate timeIntervalSinceReferenceDate] - kLoggedInTimeoutInterval + kLoggedInTimeoutAfterPourInterval);
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didChangeTemperature:(double)temperature {
  [dataStore_ addKegTemperature:temperature keg:[dataStore_ kegAtPosition:0] error:nil];
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didReceiveRFIDTagId:(NSString *)tagId {
  // TODO(johnb): tagId is coming in with some giberish
  tagId = [tagId gh_strip];
  
  if ([NSString gh_isBlank:tagId]) return;
  
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

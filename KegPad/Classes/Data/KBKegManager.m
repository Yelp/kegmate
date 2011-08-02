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
#import "KBRKDrink.h"
#import "KBRKThermoLog.h"
#import "KBRKAuthToken.h"

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

- (KBUser *)loginWithTagId:(NSString *)tagId {
  // TODO(johnb): tagId is coming in with some giberish
  tagId = [tagId gh_strip];
  
  KBRKAuthToken *authToken = [[KBRKAuthToken alloc] init];
  authToken.identifier = tagId;
  [authToken getWithDelegate:self];

  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *authTokenMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"auth_token"];
  [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/auth-tokens/magstripe.%@/?api_key=%@", tagId, [KBApplication apiKey], nil]
                             objectMapping:authTokenMapping
                                  delegate:self];
  
//  if ([NSString gh_isBlank:tagId]) return nil;
//
//  KBUser *user = (tagId ? [dataStore_ userWithTagId:tagId error:nil] : nil);
//  if (user) {
//    [self login:user];
//    [[KBApplication sharedDelegate] playSystemSoundGlass];
//    KBDebug(@"RFID=%@, user=%@", tagId, user);
//  }
//  return user;
  return nil;
}

- (void)_logout:(BOOL)postNotification {
  //[tagId_ release];
  //tagId_ = nil;
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

  KBRKDrink *drink = [[KBRKDrink alloc] init];
  drink.ticks = [NSNumber numberWithInt:(amount / KB_VOLUME_PER_TICK)];
  drink.volumeMl = [NSNumber numberWithDouble:(amount * 1000)];
  drink.pourTime = [NSDate date];
  drink.status = @"valid";
  //drink.kegId = currentKeg.identifier
  drink.username = username_;

  double maxPourAmountInLiters = [[NSUserDefaults standardUserDefaults] gh_doubleForKey:@"MaxPourAmountInLiters" withDefault:2.5];

  if (amount > 0 && amount <= maxPourAmountInLiters) {
    [drink postToAPIWithDelegate:nil];
    // XXX(johnb): Bring this feature back
    /*
    KBKegPour *lastPour = [dataStore_ lastPour:nil];
    // If same user and less than 30 seconds, add to the existing pour
    if ([lastPour.user isEqual:self.loginUser] && -[lastPour.date timeIntervalSinceNow] < 30) {
      lastPour.amountValue += amount;
      [dataStore_ addAmount:amount toPour:lastPour error:nil];
      kegPour = lastPour;
    } else {
      kegPour = [dataStore_ addKegPour:amount keg:[dataStore_ kegAtPosition:0] user:self.loginUser date:[NSDate date] error:nil];
    }
     */
  }

  pouring_ = NO;
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidEndPourNotification object:drink];

  // Set timer to timeout in kLoggedInTimeoutAfterPourInterval seconds after a pour
  self.activityTime = ([NSDate timeIntervalSinceReferenceDate] - kLoggedInTimeoutInterval + kLoggedInTimeoutAfterPourInterval);
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didChangeTemperature:(double)temperature {
  BOOL save = NO;
  
  if (save) {
    //[dataStore_ addKegTemperature:temperature keg:[dataStore_ kegAtPosition:0] error:nil];
  } else {
    KBRKThermoLog *thermoLog = [[KBRKThermoLog alloc] init];
    thermoLog.temperatureC = [NSNumber numberWithDouble:temperature];
    // TODO(johnb): Make the sensor id configurable?
    thermoLog.sensorId = @"1";
    [thermoLog postToAPIWithDelegate:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KBRKThermoLogDidChangeNotification object:thermoLog];
  }
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didReceiveRFIDTagId:(NSString *)tagId {
  [self loginWithTagId:tagId];
}

- (void)kegProcessing:(KBKegProcessing *)kegProcessing didUpdatePourWithAmount:(double)amount flowRate:(double)flowRate {
  [[NSNotificationCenter defaultCenter] postNotificationName:KBKegDidUpdatePourNotification object:kegProcessing];
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  NSLog(@"Loaded objects: %@", objects);
  id object = [objects gh_firstObject];
  if ([object isKindOfClass:[KBRKAuthToken class]]) {
    username_ = [object username];
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
  [alert show];
  NSLog(@"Hit error: %@", error);
}

#pragma mark RKRequestDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
  NSLog(@"%@", response);
  
}

@end

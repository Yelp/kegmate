//
//  KBTwitterShare.m
//  KegPad
//
//  Created by Gabriel Handford on 5/10/11.
//  Copyright 2011. All rights reserved.
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


#import "KBTwitterShare.h"

#import "KBNotifications.h"
#import "KBRKDrink.h"
#import "KBUser.h"
#import "KBKeg.h"
#import "KBBeer.h"

@interface KBTwitterShare ()
@property (retain, nonatomic) KBRKThermoLog *lastThermoLog;
@property (retain, nonatomic) KBKeg *lastKeg;
@end


@implementation KBTwitterShare

@synthesize lastThermoLog=lastThermoLog_, lastKeg=lastKeg_;

- (id)init {
  if ((self = [super init])) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidEndPour:) name:KBKegDidEndPourNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegTemperatureDidChange:) name:KBRKThermoLogDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegSelectionDidChange:) name:KBKegSelectionDidChangeNotification object:nil];    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:KBTwitterCredentialsDidChange object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  twitterEngine_.delegate = nil;
  [twitterEngine_ release];
  [lastThermoLog_ release];
  [lastKeg_ release];
  [super dealloc];
}

- (void)close {
  twitterEngine_.delegate = nil;
  [twitterEngine_ release];
  twitterEngine_ = nil;
}

- (BOOL)connect {
  [self close];
  
  NSString *consumerKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterConsumerKey"];
  NSString *consumerSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterConsumerSecret"];
  NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterAccessToken"];
  NSString *accessTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterAccessTokenSecret"];
  
  if ([NSString gh_isBlank:accessToken] || [NSString gh_isBlank:accessTokenSecret] || [NSString gh_isBlank:consumerKey] || [NSString gh_isBlank:consumerSecret]) {
    return NO;
  }

  twitterEngine_ = [[MGTwitterEngine alloc] initWithDelegate:self];
  [twitterEngine_ setUsesSecureConnection:NO];
  [twitterEngine_ setConsumerKey:consumerKey secret:consumerSecret];
  OAToken *token = [[[OAToken alloc] initWithKey:accessToken secret:accessTokenSecret] autorelease];
  [twitterEngine_ setAccessToken:token];
  return YES;
}

- (BOOL)sendUpdateWithStatus:(NSMutableString *)status {
  if (!twitterEngine_ && ![self connect]) return NO;
  
  NSString *kegPadName = [self kegPadName];
  if (kegPadName) [status appendFormat:@" (%@)", kegPadName];
  
  [twitterEngine_ sendUpdate:status];
  return YES;
}

- (void)requestSucceeded:(NSString *)connectionIdentifier {
  KBDebug(@"Request succeeded; connectionIdentifier=%@", connectionIdentifier);
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
  [self close];
  KBDebug(@"Request failed; connectionIdentifier=%@, error=%@ (%@)", connectionIdentifier, [error localizedDescription], [error userInfo]);
}

- (NSString *)kegPadName {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"KegPadName"];
}

#pragma mark - 

- (void)_kegTemperatureDidChange:(NSNotification *)notification {
  self.lastThermoLog = [notification object];
}

- (void)_kegSelectionDidChange:(NSNotification *)notification {
  KBKeg *keg = [notification object];
  if (![self.lastKeg isEqual:keg]) {
    self.lastKeg = keg;
    
    NSMutableString *status = [NSMutableString stringWithFormat:@"\"%@\" [ABV:%@] has been tapped!",
                               [self.lastKeg.beer name],
                               [self.lastKeg.beer abv]];
    [self sendUpdateWithStatus:status];
  }
}

- (void)_kegDidEndPour:(NSNotification *)notification {
  BOOL tweetAnonymous = [[NSUserDefaults standardUserDefaults] gh_boolForKey:@"TweetAnonymous" withDefault:NO];
/*
  KBRKDrink *drink = [KBRKDrink object];
  // Only tweet if larger than 3 ounces
  if (drink && [drink amountInOunces] > 3) {
    NSString *name = drink.username;
    if (!name && !tweetAnonymous) return;

    if (!name) name = @"I";

    //NSMutableString *status = [NSMutableString stringWithFormat:@"%@ poured %@ oz. of %@. %@", 
    //                           name, 
    //                           [drink amountValueDescriptionInOunces],
    //                           [drink.keg.beer name],
    //                           [drink.keg shortStatusDescriptionWithTemperature:self.lastThermoLog]];
    [self sendUpdateWithStatus:status];
  }
*/
}

@end

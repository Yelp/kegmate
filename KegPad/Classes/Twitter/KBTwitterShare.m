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
#import "KBKegPour.h"
#import "KBUser.h"
#import "KBKeg.h"
#import "KBBeer.h"


@implementation KBTwitterShare

- (id)init {
  if ((self = [super init])) {    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidEndPour:) name:KBKegDidEndPourNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:KBTwitterCredentialsDidChange object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  twitterEngine_.delegate = nil;
  [twitterEngine_ release];
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

- (BOOL)sendUpdateWithStatus:(NSString *)status {
  if (!twitterEngine_ && ![self connect]) return NO;
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

#pragma mark - 

- (void)_kegDidEndPour:(NSNotification *)notification {
  KBKegPour *kegPour = [notification object];
  if (kegPour) {
    NSString *status = [NSString stringWithFormat:@"%@ just poured %@ oz. (%@)", [kegPour.user displayName], [kegPour amountValueDescriptionInOunces], [kegPour.keg.beer name]];
    [self sendUpdateWithStatus:status];
  }
}

@end

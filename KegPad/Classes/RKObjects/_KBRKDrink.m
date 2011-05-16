//
//  _KBRKDrink.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKDrink.h"


@implementation _KBRKDrink

@dynamic identifier;
@dynamic ticks;
@dynamic volumeMl;
@dynamic sessionId;
@dynamic pourTime;
@dynamic duration;
@dynamic status;
@dynamic kegId;
@dynamic userId;
@dynamic authTokenId;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"ticks", @"ticks",
          @"volume_ml", @"volumeMl",
          @"session_id", @"sessionId",
          @"pour_time", @"pourTime",
          @"duration", @"duration",
          @"status", @"status",
          @"keg_id", @"kegId",
          @"user_id", @"userId",
          @"auth_token_id", @"authTokenId",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
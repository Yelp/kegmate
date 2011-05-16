//
//  _KBRKUserSession.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKUserSession.h"


@implementation _KBRKUserSession

@dynamic identifier;
@dynamic sessionId;
@dynamic username;
@dynamic kegId;
@dynamic startTime;
@dynamic endTime;
@dynamic volumeMl;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"session_id", @"sessionId",
          @"username", @"username",
          @"keg_id", @"kegId",
          @"start_time", @"startTime",
          @"end_time", @"endTime",
          @"volume_ml", @"volumeMl",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
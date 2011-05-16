//
//  _KBRKSystemEvent.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKSystemEvent.h"


@implementation _KBRKSystemEvent

@dynamic identifier;
@dynamic type;
@dynamic time;
@dynamic drinkId;
@dynamic kegId;
@dynamic sessionId;
@dynamic userId;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"type", @"type",
          @"time", @"time",
          @"drink_id", @"drinkId",
          @"keg_id", @"kegId",
          @"session_id", @"sessionId",
          @"user_id", @"userId",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
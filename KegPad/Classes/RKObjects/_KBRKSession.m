//
//  _KBRKSession.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKSession.h"


@implementation _KBRKSession

@dynamic identifier;
@dynamic startTime;
@dynamic endTime;
@dynamic volumeMl;
@dynamic name;
@dynamic slug;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"start_time", @"startTime",
          @"end_time", @"endTime",
          @"volume_ml", @"volumeMl",
          @"name", @"name",
          @"slug", @"slug",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
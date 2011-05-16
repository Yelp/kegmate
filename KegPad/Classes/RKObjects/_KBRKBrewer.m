//
//  _KBRKBrewer.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKBrewer.h"


@implementation _KBRKBrewer

@dynamic identifier;
@dynamic name;
@dynamic country;
@dynamic originState;
@dynamic originCity;
@dynamic production;
@dynamic url;
@dynamic descriptionText;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"name", @"name",
          @"country", @"country",
          @"origin_state", @"originState",
          @"origin_city", @"originCity",
          @"production", @"production",
          @"url", @"url",
          @"description", @"descriptionText",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
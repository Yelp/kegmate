//
//  _KBRKBeerType.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKBeerType.h"


@implementation _KBRKBeerType

@synthesize identifier;
@synthesize name;
@synthesize brewerId;
@synthesize styleId;
@synthesize edition;
@synthesize caloriesOz;
@synthesize carbsOz;
@synthesize abv;
@synthesize originalGravity;
@synthesize specificGravity;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"name", @"name",
          @"brewer_id", @"brewerId",
          @"style_id", @"styleId",
          @"edition", @"edition",
          @"calories_oz", @"caloriesOz",
          @"carbs_oz", @"carbsOz",
          @"abv", @"abv",
          @"original_gravity", @"originalGravity",
          @"specific_gravity", @"specificGravity",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
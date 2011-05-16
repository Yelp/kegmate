//
//  _KBRKBeerStyle.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKBeerStyle.h"


@implementation _KBRKBeerStyle

@dynamic identifier;
@dynamic name;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"name", @"name",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
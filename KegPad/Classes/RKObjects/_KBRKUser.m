//
//  _KBRKUser.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKUser.h"


@implementation _KBRKUser

@dynamic username;
@dynamic mugshotUrl;
@dynamic isActive;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"username", @"username",
          @"mugshot_url", @"mugshotUrl",
          @"is_active", @"isActive",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
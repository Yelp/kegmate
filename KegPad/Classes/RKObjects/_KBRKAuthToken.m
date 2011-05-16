//
//  _KBRKAuthToken.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKAuthToken.h"


@implementation _KBRKAuthToken

@dynamic identifier;
@dynamic authDevice;
@dynamic tokenValue;
@dynamic username;
@dynamic niceName;
@dynamic enabled;
@dynamic createdTime;
@dynamic expireTime;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"auth_device", @"authDevice",
          @"token_value", @"tokenValue",
          @"username", @"username",
          @"nice_name", @"niceName",
          @"enabled", @"enabled",
          @"created_time", @"createdTime",
          @"expire_time", @"expireTime",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
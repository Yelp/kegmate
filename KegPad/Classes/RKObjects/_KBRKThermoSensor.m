//
//  _KBRKThermoSensor.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKThermoSensor.h"


@implementation _KBRKThermoSensor

@dynamic identifier;
@dynamic sensorName;
@dynamic niceName;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"sensor_name", @"sensorName",
          @"nice_name", @"niceName",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
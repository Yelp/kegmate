//
//  _KBRKThermoLog.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKThermoLog.h"


@implementation _KBRKThermoLog

@dynamic identifier;
@dynamic sensorId;
@dynamic temperatureC;
@dynamic recordTime;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"sensor_id", @"sensorId",
          @"temperature_c", @"temperatureC",
          @"record_time", @"recordTime",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
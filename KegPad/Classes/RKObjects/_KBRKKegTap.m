//
//  _KBRKKegTap.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKKegTap.h"


@implementation _KBRKKegTap

@dynamic identifier;
@dynamic name;
@dynamic meterName;
@dynamic mlPerTick;
@dynamic descriptionText;
@dynamic currentKegId;
@dynamic thermoSensorId;
@dynamic lastTemperature;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"name", @"name",
          @"meter_name", @"meterName",
          @"ml_per_tick", @"mlPerTick",
          @"description", @"descriptionText",
          @"current_keg_id", @"currentKegId",
          @"thermo_sensor_id", @"thermoSensorId",
          @"last_temperature", @"lastTemperature",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
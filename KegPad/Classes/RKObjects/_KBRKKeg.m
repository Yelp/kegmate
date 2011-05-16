//
//  _KBRKKeg.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//

#import "_KBRKKeg.h"


@implementation _KBRKKeg

@dynamic identifier;
@dynamic typeId;
@dynamic sizeId;
@dynamic sizeName;
@dynamic sizeVolumeMl;
@dynamic volumeMlRemain;
@dynamic percentFull;
@dynamic startedTime;
@dynamic finishedTime;
@dynamic status;
@dynamic descriptionText;
@dynamic spilledMl;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
  return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"type_id", @"typeId",
          @"size_id", @"sizeId",
          @"size_name", @"sizeName",
          @"size_volume_ml", @"sizeVolumeMl",
          @"volume_ml_remain", @"volumeMlRemain",
          @"percent_full", @"percentFull",
          @"started_time", @"startedTime",
          @"finished_time", @"finishedTime",
          @"status", @"status",
          @"description", @"descriptionText",
          @"spilled_ml", @"spilledMl",
          nil];
}

+ (NSString*)primaryKeyProperty {
  return @"identifier";
}

#pragma mark -

@end
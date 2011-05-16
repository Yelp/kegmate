//
//  KBRKKeg.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKKeg.h"


@implementation KBRKKeg

@synthesize identifier=_identifier, statusNumber=_statusNumber, volumeRemainingNumber=_volumeRemainingNumber, startedDate=_startedDate,
finishedDate=_finishedDate, descriptionText=_descriptionText, typeId=_typeId, sizeIdNumber=_sizeIdNumber, percentFullNumber=_percentFullNumber;

#pragma mark RKObjectMappable methods

+ (NSDictionary*)elementToPropertyMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
          @"id", @"identifier",
          @"statusNumber", @"statusNumber",
          @"volume_ml_remain", @"volumeRemainingNumber",
          @"started_time", @"startedDate",
          @"finished_time", @"finishedDate",
          @"description", @"descriptionText",
          @"type_id", @"typeId",
          @"size_id", @"sizeIdNumber",
          @"percent_full", @"percentFullNumber",
          nil];
}

/*
+ (NSDictionary*)elementToRelationshipMappings {
	return [NSDictionary dictionaryWithKeysAndObjects:
          @"user", @"user",
          nil];
}
*/

#pragma mark -

- (void)dealloc {
  [_startedDate release];
  [_finishedDate release];
  [_descriptionText release];
  [_typeId release];
  [super dealloc];
}

- (NSString*)description {
  return [NSString stringWithFormat:@"KBRKKeg: %@", _descriptionText];
}

@end

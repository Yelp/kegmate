//
//  KBRKThermoLog.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//
//  Temperature sensors emit periodic data, which are recorded as ThermoLog records.

#import "_KBRKThermoLog.h"

@interface KBRKThermoLog : _KBRKThermoLog { }

+ (float)min;

+ (float)max;

- (RKRequest *)postToAPIWithDelegate:(id)delegate;

- (NSString *)thermometerDescription;

- (NSString *)temperatureDescription;

- (NSString *)statusDescription;

@end

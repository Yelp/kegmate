//
//  _KBRKThermoLog.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  Temperature sensors emit periodic data, which are recorded as ThermoLog records.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKThermoLog : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The ThermoSensor which recorded the entry.
@property (retain, nonatomic) NSString *sensorId;
//! Temperature, in degrees celcius.
@property (retain, nonatomic) NSNumber *temperatureC;
//! Time of recording.
@property (retain, nonatomic) NSDate *recordTime;

@end

//
//  _KBRKThermoSensor.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  Represents a temperature sensor in the Kegbot system.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKThermoSensor : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The raw and unique name for the sensor.
@property (retain, nonatomic) NSString *sensorName;
//! A human-readable, descriptive name for the sensor.
@property (retain, nonatomic) NSString *niceName;

@end

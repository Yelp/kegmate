//
//  _KBRKKegTap.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  Every available beer tap in the system is modeled by a KegTap.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKKegTap : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! A short, descriptive name for the tap.
@property (retain, nonatomic) NSString *name;
//! The name of the flow meter that is assigned to this tap.
@property (retain, nonatomic) NSString *meterName;
//! Volume to record per tick of the corresponding flow meter, in milliliters.
@property (retain, nonatomic) NSNumber *mlPerTick;
//! A longer description of the tap, or null if not known.
@property (retain, nonatomic) NSString *descriptionText;
//! The Keg currently assigned to the tap, or null.
@property (retain, nonatomic) NSString *currentKegId;
//! The ThermoSensor assigned to the tap, or null.
@property (retain, nonatomic) NSString *thermoSensorId;
//! The last recorded temperature of the attached temperature sensor, in degrees C, or null if no sensor configured.
@property (retain, nonatomic) NSNumber *lastTemperature;

@end

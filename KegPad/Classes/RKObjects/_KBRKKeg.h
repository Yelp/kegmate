//
//  _KBRKKeg.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  A Keg object records an instance of a particular type and quantity of beer.  In
//  a running system, a Keg will be instantiated and linked to an active
//  KegTap.  A Drink recorded against that tap deducts
//  from the known remaining volume.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKKeg : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The BeerType for this beer.
@property (retain, nonatomic) NSString *typeId;
//! The KegSize of this keg.
@property (retain, nonatomic) NSString *sizeId;
//! The name of the KegSize of this keg.
@property (retain, nonatomic) NSString *sizeName;
//! The total volume, in milliliters, for the KegSize of this keg.
@property (retain, nonatomic) NSNumber *sizeVolumeMl;
//! The total volume remaining, in milliliters.
@property (retain, nonatomic) NSNumber *volumeMlRemain;
//! The total volume remaining, as a percentage value between 0.0 and 100.0.
@property (retain, nonatomic) NSNumber *percentFull;
//! The time when the keg was first started, or tapped.
@property (retain, nonatomic) NSDate *startedTime;
//! The time when the keg was finished, or emptied.  This value is undefined if the keg’s status is not “offline”.
@property (retain, nonatomic) NSDate *finishedTime;
//! Current status of the keg; either “online” or “offline”.
@property (retain, nonatomic) NSString *status;
//! A site-specific description of this keg, or null if not known.
@property (retain, nonatomic) NSString *descriptionText;
//! Total volume marked as spilled, in milliliters.
@property (retain, nonatomic) NSNumber *spilledMl;

@end

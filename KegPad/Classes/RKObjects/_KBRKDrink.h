//
//  _KBRKDrink.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  Drink objects represent a specific pour.  Typically, but not always, the Drink
//  object lists the user known to have poured it, as well as the keg from which it
//  came.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKDrink : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The number of flow meter ticks recorded for this drink.  Note that this value should never change once set, regardless of the volume_ml property.
@property (retain, nonatomic) NSNumber *ticks;
//! The volume of the pour, in milliliters.
@property (retain, nonatomic) NSNumber *volumeMl;
//! Session that this drink belongs to.
@property (retain, nonatomic) NSString *sessionId;
//! The date of the pour.
@property (retain, nonatomic) NSDate *pourTime;
//! The duration of the pour, in seconds, or null if not known.
@property (retain, nonatomic) NSNumber *duration;
//! The status of the drink: one of “valid” or “invalid”.
@property (retain, nonatomic) NSString *status;
//! The Keg from which the drink was poured, or null if not known.
@property (retain, nonatomic) NSString *kegId;
//! The User who poured the drink, or null if not known.
@property (retain, nonatomic) NSString *userId;
//! The AuthToken used to pour the drink, or null if not known.
@property (retain, nonatomic) NSString *authTokenId;

@end

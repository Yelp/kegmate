//
//  _KBRKBeerType.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  A BeerType identifies a specific beer, produced by a specific
//  Brewer, and often in a particular BeerStyle.  Several
//  traits of the beer, such as its alcohol content, may also be given.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKBeerType : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The brand name of the beer.
@property (retain, nonatomic) NSString *name;
//! The identifier for the Brewer  which produces this beer.
@property (retain, nonatomic) NSString *brewerId;
//! The identifier for the style of this beer.
@property (retain, nonatomic) NSString *styleId;
//! For seasonal or special edition version of a beers, the year or other indicative name; null otherwise.
@property (retain, nonatomic) NSString *edition;
//! The number of calories per fluid ounce of beer, or null if not known.
@property (retain, nonatomic) NSNumber *caloriesOz;
//! Number of carbohydrates per ounce of beer, or null if not known.
@property (retain, nonatomic) NSNumber *carbsOz;
//! Alcohol by volume, as as percentage value between 0.0 and 100.0, or null if not known.
@property (retain, nonatomic) NSNumber *abv;
//! Original gravity of this beer, or null  if not known.
@property (retain, nonatomic) NSNumber *originalGravity;
//! Specific gravity of this beer, or null  if not known.
@property (retain, nonatomic) NSNumber *specificGravity;

@end

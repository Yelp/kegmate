//
//  _KBRKKegSize.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  A KegSize is a small object that gives a name and a volume to a particular
//  quantity.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKKegSize : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! Name of this size.
@property (retain, nonatomic) NSString *name;
//! Total volume of this size, in milliliters.
@property (retain, nonatomic) NSNumber *volumeMl;

@end

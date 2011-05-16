//
//  _KBRKSession.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  A Session is used to group drinks that are close to eachother in time.  Every
//  Drink is assigned to a session.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKSession : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The time of the first Drink  in the session.
@property (retain, nonatomic) NSDate *startTime;
//! The time of the last (most recent) Drink in the session.
@property (retain, nonatomic) NSDate *endTime;
//! Total volume poured, among all drinks in the session.
@property (retain, nonatomic) NSNumber *volumeMl;
//! A descriptive name for the session; may be empty if no name has been set.
@property (retain, nonatomic) NSString *name;
//! A variation of the 
@property (retain, nonatomic) NSString *slug;

@end

//
//  _KBRKSystemEvent.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  This object describes a system-wide event. System events are generated in
//  response to drink and keg configuration activity.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKSystemEvent : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The type of system event. Currently-defined event types: drink_poured, session_started, session_joined, keg_tapped, keg_ended.
@property (retain, nonatomic) NSString *type;
//! The time of the event.
@property (retain, nonatomic) NSDate *time;
//! The Drink that this event concerns; may be null.
@property (retain, nonatomic) NSString *drinkId;
//! The Keg that this event concerns; may be null.
@property (retain, nonatomic) NSString *kegId;
//! The Session that this event concerns; may be null.
@property (retain, nonatomic) NSString *sessionId;
//! The User that this event concerns; may be null.
@property (retain, nonatomic) NSString *userId;

@end

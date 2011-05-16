//
//  _KBRKUserSession.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  A UserSession describe’s a particular user’s contribution to a
//  Session, for a particular Keg.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKUserSession : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The Session that was contributed to.
@property (retain, nonatomic) NSString *sessionId;
//! The User.
@property (retain, nonatomic) NSString *username;
//! The Keg that was contributed to.
@property (retain, nonatomic) NSString *kegId;
//! Time of the user’s first activity.
@property (retain, nonatomic) NSDate *startTime;
//! Time of the user’s last activity.
@property (retain, nonatomic) NSDate *endTime;
//! Total volume poured by this user in the session.
@property (retain, nonatomic) NSNumber *volumeMl;

@end

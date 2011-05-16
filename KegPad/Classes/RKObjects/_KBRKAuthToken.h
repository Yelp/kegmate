//
//  _KBRKAuthToken.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  An AuthToken object represents a unique key that identifies a user.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKAuthToken : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! The name of the authentication device owning this token (for example, 
@property (retain, nonatomic) NSString *authDevice;
//! The device-specific token value.  For instance, on onewire devices, the token value will be a hexadecimal string giving the unique 64-bit id.
@property (retain, nonatomic) NSString *tokenValue;
//! The username the token is bound to, or null if the token is unassigned.
@property (retain, nonatomic) NSString *username;
//! An admin-configurable “nice name”, or alias, for this token instance. May be null if the token does not have a nice name.
@property (retain, nonatomic) NSString *niceName;
//! Whether the token is active.
@property (retain, nonatomic) NSNumber *enabled;
//! The date the token was created or activated.
@property (retain, nonatomic) NSDate *createdTime;
//! The date after which the token is no longer valid, or null if there is no expiration.
@property (retain, nonatomic) NSDate *expireTime;

@end

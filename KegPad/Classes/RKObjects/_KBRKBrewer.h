//
//  _KBRKBrewer.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//  Auto-generated from KegBot.org docs
//
//  A Brewer is a producer of beer.

#import <RestKit/RestKit.h>
#import <RestKit/CoreData/CoreData.h>

@interface _KBRKBrewer : RKManagedObject { }

//! An opaque, unique identifier for this object.
@property (retain, nonatomic) NSString *identifier;
//! Name of the brewer
@property (retain, nonatomic) NSString *name;
//! Country where the brewer is based; may be an empty string.
@property (retain, nonatomic) NSString *country;
//! State or province where the brewer is based; may be an empty string.
@property (retain, nonatomic) NSString *originState;
//! City where the brewer is based; may be an empty string.
@property (retain, nonatomic) NSString *originCity;
//! Type of production, either “commercial” or “homebrew”; may be an empty string.
@property (retain, nonatomic) NSString *production;
//! Homepage of the brewer; may be an empty string.
@property (retain, nonatomic) NSNumber *url;
//! Free-form description of the brewer; may be an empty string.
@property (retain, nonatomic) NSString *descriptionText;

@end

//
//  KBRKBeersViewController.m
//  KegPad
//
//  Created by John Boiles on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKBeersViewController.h"
#import "KBRKBeerType.h"

@implementation KBRKBeersViewController

- (void)loadBeers {
  // Load the object model via RestKit
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectLoader* loader = [objectManager loadObjectsAtResourcePath:@"/beertypes" objectClass:[KBRKBeerType class] delegate:self];
  loader.keyPath = @"result.beertypes";
}

@end

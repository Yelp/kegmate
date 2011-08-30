//
//  KBDataRouter.h
//  KegPad
//
//  Created by John Boiles on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Handle loading and saving of data either from a local store or from an API

#import <Foundation/Foundation.h>
#import "KBRKUser.h"
#import "KBRKDrink.h"
#import "KBRKKeg.h"
#import "KBRKThermoLog.h"

@interface KBDataRouter : NSObject <RKObjectLoaderDelegate> {
  void (^userWithAuthKeyBlock_)(KBRKUser *user, NSError *error);
}

- (void)userWithAuthKey:(NSString *)authKey completion:(void (^)(KBRKUser *user, NSError *error))completion;

- (void)addDrink:(KBRKDrink *)drink completion:(void (^)(KBRKDrink *drink, NSError *error))completion;

- (void)addThermoLog:(KBRKThermoLog *)thermoLog completion:(void (^)(KBRKThermoLog *thermoLog, NSError *error))completion;

- (KBRKKeg *)currentKeg;

@end

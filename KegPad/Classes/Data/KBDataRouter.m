//
//  KBDataRouter.m
//  KegPad
//
//  Created by John Boiles on 8/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBDataRouter.h"
#import "KBApplication.h"
#import "KBRKAuthToken.h"

@implementation KBDataRouter

- (id)init
{
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)userWithAuthKey:(NSString *)authKey completion:(void (^)(KBRKUser *, NSError *))completion {
  userWithAuthKeyBlock_ = completion;
  KBRKAuthToken *authToken = [[KBRKAuthToken alloc] init];
  authToken.identifier = authKey;
  [authToken getWithDelegate:self];
  
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *authTokenMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"auth_token"];
  [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"/auth-tokens/magstripe.%@/?api_key=%@", authKey, [KBApplication apiKey], nil]
                             objectMapping:authTokenMapping
                                  delegate:self];
}

- (void)addDrink:(KBRKDrink *)drink completion:(void (^)(KBRKDrink *drink, NSError *error))completion {
  [drink postToAPIWithDelegate:self];
}

- (void)addThermoLog:(KBRKThermoLog *)thermoLog completion:(void (^)(KBRKThermoLog *thermoLog, NSError *error))completion {
  [thermoLog postToAPIWithDelegate:self];
}

- (KBRKKeg *)currentKeg {
  
}

#pragma mark RKObjectLoaderDelegate

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  NSLog(@"Loaded objects: %@", objects);
  id object = [objects gh_firstObject];
  if ([object isKindOfClass:[KBRKAuthToken class]]) {
    KBRKUser *user = [[KBRKUser alloc] init];
    user.username = [object username];
    userWithAuthKeyBlock_(user, nil);
    userWithAuthKeyBlock_ = NULL;
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {
  UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
  [alert show];
  NSLog(@"Hit error: %@", error);
}

#pragma mark RKRequestDelegate

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
  NSLog(@"%@", response);
  
}

@end

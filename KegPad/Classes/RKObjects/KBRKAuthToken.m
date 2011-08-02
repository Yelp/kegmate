//
//  KBRKAuthToken.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//

#import "KBRKAuthToken.h"
#import "KBApplication.h"

@implementation KBRKAuthToken

- (RKRequest *)getWithDelegate:(id)delegate {
  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [KBApplication apiKey], @"api_key",
                          nil];
  return [[RKClient sharedClient] get:[NSString stringWithFormat:@"/auth-tokens/magstripe.%@/", self.identifier] queryParams:params delegate:delegate];
}

@end
//
//  KBRKDrink.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//

#import "KBRKDrink.h"
#import "KBTypes.h"
#import "KBApplication.h"

@implementation KBRKDrink

- (NSString *)amountDescriptionWithTimeAgo {
  NSString *timeAgo = nil;
  if (-[self.pourTime timeIntervalSinceNow] < 60.0) {
    timeAgo = @"just now";
  } else {
    timeAgo = [NSString stringWithFormat:@"%@ ago", [self.pourTime gh_timeAgo:NO]];
  }  
  return [NSString stringWithFormat:@"%0.1f oz. %@", (([self.volumeMl doubleValue] / 1000) * kLitersToOunces), timeAgo];
}

- (RKRequest *)postToAPIWithDelegate:(id)delegate {
  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.ticks, @"ticks",
                          [KBApplication apiKey], @"api_key",
                          nil];
  return [[RKClient sharedClient] post:@"/taps/kegboard.flow0/" params:params delegate:delegate];
}

- (float)amountInOunces {
  return (([self.volumeMl doubleValue] / 1000) * kLitersToOunces);
}

@end
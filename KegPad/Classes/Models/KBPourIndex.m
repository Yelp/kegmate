//
//  KBPourIndex.m
//  KegPad
//
//  Created by Gabriel Handford on 10/13/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBPourIndex.h"


@implementation KBPourIndex

- (NSString *)pouredDescription {
  if (self.pourCountValue == 1) {
    return [NSString stringWithFormat:@"1 pour (%0.1f liters)", self.volumePouredValue];
  } else {
    return [NSString stringWithFormat:@"%d pours (%0.1f liters)", self.pourCountValue, self.volumePouredValue];
  }
}

@end

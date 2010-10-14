//
//  KBUser.m
//  KegPad
//
//  Created by Gabriel Handford on 7/29/10.
//  Copyright 2010 Yelp. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "KBUser.h"

@implementation KBUser

- (NSString *)displayName {
  return [NSString stringWithFormat:@"%@ %@.", self.firstName, [self.lastName substringToIndex:1]];
}

- (NSString *)fullName {
  return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (void)addPouredValue:(float)poured {
  self.volumePouredValue += poured;
  self.pourCountValue += 1;
}

- (NSString *)pouredDescription {
  if (self.pourCountValue == 1) {
    return [NSString stringWithFormat:@"1 pour (%0.1f liters)", self.volumePouredValue];
  } else {
    return [NSString stringWithFormat:@"%d pours (%0.1f liters)", self.pourCountValue, self.volumePouredValue];
  }
}

@end

//
//  KBKegPour.m
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

#import "KBKegPour.h"
#import "KBTypes.h"

@implementation KBKegPour

- (NSString *)amountValueDescriptionInOunces {
  return [NSString stringWithFormat:@"%d", (int)roundf(self.amountValue * kLitersToOunces)];
}

- (NSString *)amountDescription {
  return [NSString stringWithFormat:@"%0.1f oz.", (self.amountValue * kLitersToOunces)];
}

- (NSString *)amountDescriptionWithTimeAgo {
  NSString *timeAgo = nil;
  if (-[self.date timeIntervalSinceNow] < 60.0) {
    timeAgo = @"just now";
  } else {
    timeAgo = [NSString stringWithFormat:@"%@ ago", [self.date gh_timeAgo:NO]];
  }  
  return [NSString stringWithFormat:@"%0.1f oz. %@", (self.amountValue * kLitersToOunces), timeAgo];
}

- (NSInteger)timeAgoInteger:(NSDate *)date {
  NSTimeInterval intervalInSeconds = fabs([date timeIntervalSinceNow]);
  double intervalInMinutes = round(intervalInSeconds/60.0);  
  if (intervalInMinutes <= 89) {
    return intervalInMinutes;
  } else {
    return round(intervalInMinutes/60.0);
  }  
}

- (NSString *)timeAgoUnitsDescription:(NSDate *)date {
  NSTimeInterval intervalInSeconds = fabs([date timeIntervalSinceNow]);
  double intervalInMinutes = round(intervalInSeconds/60.0);  
  if (intervalInMinutes <= 89) {
    return @"MINUTES AGO";
  } else {
    return @"HOURS AGO";
  }
}

@end

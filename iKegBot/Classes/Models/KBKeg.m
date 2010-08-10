//
//  KBKegTemperature.m
//  KegBot
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

#import "KBKeg.h"

@implementation KBKeg

- (float)volumeRemaingValue {
  float volumeRemaing = self.volumeTotalValue - self.volumePouredValue - self.volumeAdjustedValue;
  if (volumeRemaing < 0) return 0;
  return volumeRemaing;
}

- (float)volumeTotalPouredAdjustedValue {
  return (self.volumePouredValue + self.volumeAdjustedValue);
}

- (float)volumeRemaingPercentage {
  return ([self volumeRemaingValue] / self.volumeTotalValue) * 100.0;
}

- (void)addPouredValue:(float)poured {
  self.volumePouredValue += poured;
}

@end

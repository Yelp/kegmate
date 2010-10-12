//
//  KBKegTemperature.m
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

#import "KBKegTemperature.h"

@implementation KBKegTemperature

- (NSString *)thermometerDescription {
  float temperature = self.temperatureValue;  
  if (temperature < 10) return @"frosty!";
  else if (temperature < 16) return @"chilly!";
  return @"warm";
}

- (NSString *)statusDescription {
  float temperature = self.temperatureValue;  
  if (temperature < 10) return @"COLD CHILLIN'";
  else if (temperature < 16) return @"CHILLIN'";
  return @"WARM";
}
 
+ (float)min {
  return 4.0;
}

+ (float)max {
  return 21.0;
}

@end

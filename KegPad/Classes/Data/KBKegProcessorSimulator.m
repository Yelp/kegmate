//
//  KBKegProcessorSimulator.m
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
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

#import "KBKegProcessorSimulator.h"


@implementation KBKegProcessorSimulator

+ (void)initialize {
  srand(time(NULL));
}

- (id)initWithKegProcessor:(KBKegProcessor *)kegProcessor {
  if ((self = [self init])) {
    kegProcessor_ = [kegProcessor retain];
  }
  return self;
}

- (void)dealloc {
  [kegProcessor_ release];
  [super dealloc];
}

- (void)temperatureAndPour {
  KBKeg *keg = [kegProcessor_.dataStore kegAtPosition:0];
  KBDebug(@"Keg: %@", keg);
  // Simulate temperature reading
  [[kegProcessor_ gh_proxyAfterDelay:1] kegProcessing:kegProcessor_.processing didChangeTemperature:10.4];
  // Simulate start and end pour with random amount
  [[kegProcessor_ gh_proxyAfterDelay:2] kegProcessingDidStartPour:kegProcessor_.processing];
  [[kegProcessor_ gh_proxyAfterDelay:12] kegProcessing:kegProcessor_.processing didEndPourWithAmount:(0.2 + (rand() / (double)RAND_MAX))];   
}

- (void)login {
  KBUser *user = [kegProcessor_.dataStore userWithRFID:@"29009426DC47" error:nil];
  KBDebug(@"User: %@", user);
  [kegProcessor_ login:user];
}

- (void)unknownTag {  
  NSString *randomTagId = [NSString stringWithFormat:@"%d", [NSNumber gh_randomInteger]];
  [kegProcessor_ kegProcessing:kegProcessor_.processing didReceiveRFIDTagId:randomTagId];
}

@end

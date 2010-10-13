//
//  KBKegManagerSimulator.m
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

#import "KBKegManagerSimulator.h"


@implementation KBKegManagerSimulator

+ (void)initialize {
  srand(time(NULL));
}

- (id)initWithKegProcessor:(KBKegManager *)kegManager {
  if ((self = [self init])) {
    kegManager_ = [kegManager retain];
  }
  return self;
}

- (void)dealloc {
  [kegManager_ release];
  [super dealloc];
}

- (void)temperatureAndPour {
  // Simulate temperature reading
  [[kegManager_ gh_proxyAfterDelay:1] kegProcessing:kegManager_.processing didChangeTemperature:10.4];
  // Simulate start and end pour with random amount
  [[kegManager_ gh_proxyAfterDelay:2] kegProcessingDidStartPour:kegManager_.processing];
  [[kegManager_ gh_proxyAfterDelay:12] kegProcessing:kegManager_.processing didEndPourWithAmount:(0.2 + (rand() / (double)RAND_MAX))];   
}

- (void)temperatures {
  [[kegManager_ gh_proxyAfterDelay:1] kegProcessing:kegManager_.processing didChangeTemperature:10.4];
  [[kegManager_ gh_proxyAfterDelay:2] kegProcessing:kegManager_.processing didChangeTemperature:13.4];
  [[kegManager_ gh_proxyAfterDelay:3] kegProcessing:kegManager_.processing didChangeTemperature:15.0];
  [[kegManager_ gh_proxyAfterDelay:4] kegProcessing:kegManager_.processing didChangeTemperature:18.6];  
}

- (void)login:(NSString *)tagId {
  KBUser *user = [kegManager_.dataStore userWithTagId:tagId error:nil];
  KBDebug(@"User: %@", user);
  [kegManager_ login:user];
}

- (void)unknownTag {  
  NSString *randomTagId = [NSString stringWithFormat:@"%d", [NSNumber gh_randomInteger]];
  [kegManager_ kegProcessing:kegManager_.processing didReceiveRFIDTagId:randomTagId];
}

- (void)pours {
  [[kegManager_ gh_proxyAfterDelay:2] kegProcessingDidStartPour:kegManager_.processing];
  [[kegManager_ gh_proxyAfterDelay:3] kegProcessing:kegManager_.processing didEndPourWithAmount:(0.2 + (rand() / (double)RAND_MAX))];   
  [[kegManager_ gh_proxyAfterDelay:8] kegProcessingDidStartPour:kegManager_.processing];
  [[kegManager_ gh_proxyAfterDelay:9] kegProcessing:kegManager_.processing didEndPourWithAmount:(0.2 + (rand() / (double)RAND_MAX))];   
}

- (void)pourLong {
  [[kegManager_ gh_proxyAfterDelay:1] kegProcessingDidStartPour:kegManager_.processing];
  [[kegManager_ gh_proxyAfterDelay:30] kegProcessing:kegManager_.processing didEndPourWithAmount:(0.2 + (rand() / (double)RAND_MAX))];
}

@end

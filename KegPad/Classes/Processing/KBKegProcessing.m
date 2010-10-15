//
//  KBKegProcessing.m
//  KegPad
//
//  Created by John Boiles on 7/29/10.
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

#import "KBKegProcessing.h"


@implementation KBKegProcessing

@synthesize delegate=_delegate, flowRate=_flowRate;

- (id)init {
  if ((self = [super init])) {
    _kegboard = [[KBKegboard alloc] initWithDelegate:self];
  }
  return self;
}

- (void)dealloc {
  _kegboard.delegate = nil;
  [_kegboard release];
  [super dealloc];
}

- (void)endPour {
  if (_pouring) {
    KBDebug(@"Ended pour");
    [self.delegate kegProcessing:self didEndPourWithAmount:_lastVolume - _pourStartVolume];
    _pouring = NO;
    _pourTimeout = nil;
  }
}

- (double)pourVolume {
  return _lastVolume - _pourStartVolume;
}

#pragma mark Delegates (KBKegboard)

- (void)kegboard:(KBKegboard *)kegboard didReceiveHello:(KBKegboardMessageHello *)message {
  KBDebug(@"Hello from Kegboard!");
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message { }

- (void)kegboard:(KBKegboard *)kegboard didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message {
  // Check last few meter values, if this is significantly different, notify delegate of start / end of pour
  // Since we're receiving flow values at about 1 Hz, watch for significant changes
  double volume = [message meterReading] * KB_VOLUME_PER_TICK;

  if (!_hasVolume) {
    _lastVolume = volume;
    _hasVolume = YES;
    return;
  }

  double timestamp = [message timeStamp]; 
  _flowRate = (volume - _lastVolume) / (timestamp - _lastVolumeTimetamp);
  _lastVolumeTimetamp = timestamp;

  // Figure out if we've started to increase flow a lot since the last sample
  if (_flowRate > KB_VOLUME_DIFFERENCE_THRESHOLD) {
    if (!_pouring) {
      KBDebug(@"Pouring");
      [self.delegate kegProcessingDidStartPour:self]; 
      _pourStartVolume = _lastVolume;
      _pouring = YES;
      _pourTimeout = [NSTimer scheduledTimerWithTimeInterval:KB_POUR_TIMEOUT target:self selector:@selector(endPour) userInfo:nil repeats:NO];
    } else {
      [_pourTimeout setFireDate:[NSDate dateWithTimeIntervalSinceNow:KB_POUR_TIMEOUT]];
    }
  }
  _lastVolume = volume;
  [self.delegate kegProcessing:self didUpdatePourWithAmount:(volume - _pourStartVolume) flowRate:_flowRate];
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message {
  [self.delegate kegProcessing:self didChangeTemperature:[message sensorReading]];
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message { }

- (void)kegboard:(KBKegboard *)kegboard didReceiveRFID:(KBKegboardMessageRFID *)message {
  [self.delegate kegProcessing:self didReceiveRFIDTagId:[message tagID]];
}

- (void)kegboard:(KBKegboard *)kegboard didReceiveMagStripe:(KBKegboardMessageMagStripe *)message {
  [self.delegate kegProcessing:self didReceiveRFIDTagId:[message cardID]];
}

@end

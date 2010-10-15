//
//  KBKegboard.h
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

// TODO(johnb): implement message sending. This will allow us to reset the flow count in software
// when we install a new keg. This way we could maintain state even if the iPad is disconnected
// from the keg.

#import "Serial.h"
#import "KBKegboardMessage.h"

#define SERIAL_PORT "/dev/tty.iap"
//#define SERIAL_PORT "/Applications/SerialTest.app/TestData2NullTermination"

@class KBKegboard;

@protocol KBKegboardDelegate <NSObject>
- (void)kegboard:(KBKegboard *)kegboard didReceiveHello:(KBKegboardMessageHello *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveRFID:(KBKegboardMessageRFID *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveMagStripe:(KBKegboardMessageMagStripe *)message;
@end

@interface KBKegboard : NSObject {
  id<KBKegboardDelegate> _delegate;
  NSThread *_readLoopThread;
}

@property (assign, nonatomic) id<KBKegboardDelegate> delegate;

- (id)initWithDelegate:(id<KBKegboardDelegate>)delegate;

- (void)start;

@end



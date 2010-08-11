//
//  KBKegboard.h
//  KegBot
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

#import "Serial.h"

#define SERIAL_PORT "/dev/tty.iap"
//#define SERIAL_PORT "/Applications/SerialTest.app/TestData2NullTermination"
#define BAUD_RATE 115200
#define KBSP_PAYLOAD_MAXLEN 112
#define KBSP_PREFIX_LENGTH 8
#define kKBSP_PREFIX "KBSP v1:"
#define kKBSP_TRAILER "\r\n"
extern char *const KBSP_PREFIX;
extern char *const KBSP_TRAILER;

#define KB_MESSAGE_ID_HELLO 0x01
#define KB_MESSAGE_ID_BOARD_CONFIGURATION 0x02
#define KB_MESSAGE_ID_METER_STATUS 0x10
#define KB_MESSAGE_ID_TEMPERATURE_READING 0x11
#define KB_MESSAGE_ID_OUTPUT_STATUS 0x12
#define KB_MESSAGE_ID_RFID 0x14

@class KBKegboard;
@class KBKegboardMessageHello;
@class KBKegboardMessageBoardConfiguration;
@class KBKegboardMessageMeterStatus;
@class KBKegboardMessageTemperatureReading;
@class KBKegboardMessageOutputStatus;
@class KBKegboardMessageRFID;

@protocol KBKegboardDelegate <NSObject>
- (void)kegboard:(KBKegboard *)kegboard didReceiveHello:(KBKegboardMessageHello *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message;
- (void)kegboard:(KBKegboard *)kegboard didReceiveRFID:(KBKegboardMessageRFID *)message;
@end

@interface KBKegboard : NSObject {
  id<KBKegboardDelegate> _delegate;
  NSThread *_readLoopThread;
}

@property (assign, nonatomic) id<KBKegboardDelegate> delegate;

- (id)initWithDelegate:(id<KBKegboardDelegate>)delegate;

- (void)start;

@end


@interface KBKegboardMessage : NSObject {
  NSUInteger _messageId;
}

@property (readonly, nonatomic) NSUInteger messageId;

+ (id)messageWithId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length;
+ (NSString *)parseString:(char *)stringData length:(NSUInteger)length;
+ (NSUInteger)parseUInt32:(char *)data length:(NSUInteger)length;
+ (NSUInteger)parseUInt8:(char *)data;
+ (NSUInteger)parseUInt16:(char *)data;
+ (NSUInteger)parseUInt32:(char *)data;
+ (NSInteger)parseInt32:(char *)data;
+ (double)parseTemp:(char *)data;
+ (BOOL)parseBool:(char *)data;
- (id)initWithMessageId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length;

@end

// do later: onewire_presence, last_events, watchdog_alarm

@interface KBKegboardMessageHello : KBKegboardMessage {
  NSUInteger _protocolVersion;
}
@property (readonly, nonatomic) NSUInteger protocolVersion;
@end

@interface KBKegboardMessageBoardConfiguration : KBKegboardMessage {
  NSString *_boardName;
  NSUInteger _baudRate;
  NSUInteger _updateInterval;
  NSUInteger _watchdogTimeout;
}
@property (readonly, nonatomic) NSString *boardName;
@property (readonly, nonatomic) NSUInteger baudRate;
@property (readonly, nonatomic) NSUInteger updateInterval;
@property (readonly, nonatomic) NSUInteger watchdogTimeout;
@end

@interface KBKegboardMessageMeterStatus : KBKegboardMessage {
  NSString *_meterName;
  NSUInteger _meterReading;
}
@property (readonly, nonatomic) NSString *meterName;
@property (readonly, nonatomic) NSUInteger meterReading;
@end

@interface KBKegboardMessageTemperatureReading : KBKegboardMessage {
  NSString *_sensorName;
  double _sensorReading;
}
@property (readonly, nonatomic) NSString *sensorName;
@property (readonly, nonatomic) double sensorReading;
@end

@interface KBKegboardMessageOutputStatus : KBKegboardMessage {
  NSString *_outputName;
  BOOL _outputReading;
}
@property (readonly, nonatomic) NSString *outputName;
@property (readonly, nonatomic) BOOL outputReading;
@end

@interface KBKegboardMessageRFID : KBKegboardMessage {
  NSString *_readerName;
  NSString *_tagId;
}
@property (readonly, nonatomic) NSString *readerName;
@property (readonly, nonatomic) NSString *tagId;
@end


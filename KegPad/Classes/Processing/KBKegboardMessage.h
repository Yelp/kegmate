//
//  KBKegboardMessage.h
//  KegPad
//
//  Created by John Boiles on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#define BAUD_RATE 115200
#define KBSP_PAYLOAD_MAXLEN 112
#define KBSP_PREFIX_LENGTH 8
#define kKBSP_PREFIX "KBSP v1:"
#define kKBSP_TRAILER "\r\n"
extern char *const KBSP_PREFIX;
extern char *const KBSP_TRAILER;

// TODO(johnb): last_events, watchdog_alarm
#define KB_MESSAGE_ID_HELLO 0x01
#define KB_MESSAGE_ID_BOARD_CONFIGURATION 0x02
#define KB_MESSAGE_ID_METER_STATUS 0x10
#define KB_MESSAGE_ID_TEMPERATURE_READING 0x11
#define KB_MESSAGE_ID_OUTPUT_STATUS 0x12
#define KB_MESSAGE_ID_AUTH_TOKEN 0x14

@interface KBKegboardMessage : NSObject {
  NSUInteger _messageId;
  NSTimeInterval _timeStamp;
}
@property (readonly, nonatomic) NSUInteger messageId;
@property (readonly, assign, nonatomic) NSTimeInterval timeStamp;

+ (id)messageWithId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length timeStamp:(NSTimeInterval)timeStamp;
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

@interface KBKegboardMessageAuthToken : KBKegboardMessage {
  NSString *_deviceName;
  NSString *_token;
  BOOL _status;
}
@property (readonly, nonatomic) NSString *deviceName;
@property (readonly, nonatomic) NSString *token;
@property (readonly, nonatomic) BOOL status; // YES if present, NO if removed
@end

//
//  KBKegboardMessage.m
//  KegPad
//
//  Created by John Boiles on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBKegboardMessage.h"

char *const KBSP_PREFIX = kKBSP_PREFIX;
char *const KBSP_TRAILER = kKBSP_TRAILER;

@interface KBKegboardMessage ()
- (void)parsePayload:(char *)payload length:(NSUInteger)length;
- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length;
@end

@implementation KBKegboardMessage

@synthesize messageId=_messageId;

+ (id)messageWithId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length {
  switch (messageId) {
    case KB_MESSAGE_ID_HELLO:
      return [[[KBKegboardMessageHello alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
    case KB_MESSAGE_ID_BOARD_CONFIGURATION:
      return [[[KBKegboardMessageBoardConfiguration alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
    case KB_MESSAGE_ID_METER_STATUS:
      return [[[KBKegboardMessageMeterStatus alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
    case KB_MESSAGE_ID_TEMPERATURE_READING:
      return [[[KBKegboardMessageTemperatureReading alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
    case KB_MESSAGE_ID_OUTPUT_STATUS:
      return [[[KBKegboardMessageOutputStatus alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
    case KB_MESSAGE_ID_RFID:
      return [[[KBKegboardMessageRFID alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
    case KB_MESSAGE_ID_MAGSTRIPE:
      return [[[KBKegboardMessageMagStripe alloc] initWithMessageId:messageId payload:payload length:length] autorelease];
      break;
  }
  NSLog(@"Got unknown message with ID %x", messageId);
  return nil;
}

- (id)initWithMessageId:(NSUInteger)messageId payload:(char *)payload length:(NSUInteger)length {
  if ((self = [super init])) {
    _messageId = messageId;
    [self parsePayload:payload length:length];
  }
  return self;
}

- (void)parsePayload:(char *)payload length:(NSUInteger)length {
  NSUInteger index = 0;
  while (index < length) {
    NSUInteger tag = [KBKegboardMessage parseUInt8:&payload[index]];
    index++;
    NSUInteger length = [KBKegboardMessage parseUInt8:&payload[index]];
    index++;
    if (![self parsePayload:&payload[index] forTag:tag length:length]) NSLog(@"Failed to parse tag: %d", tag);
    index += length;
  }
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  NSAssert(NO, @"Abstract Method");
  return NO;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessage with messageId %u", _messageId];
}

+ (NSString *)parseString:(char *)stringData length:(NSUInteger)length {
  // NOTE: Kegboard docs say strings are null terminated, but in the latest version (as of 7/29/2010), they are not.
  // To be safe, check for null termination
  if (!stringData[length - 1]) length -= 1;
  return [[[NSString alloc] initWithBytes:stringData length:length encoding:NSASCIIStringEncoding] autorelease];
}

+ (NSUInteger)parseUInt32:(char *)data length:(NSUInteger)length {
  NSUInteger output = 0;
  for (NSInteger i = 0; i < length; i++) {
    output += (unsigned char)data[i] << (i * 8);
  }
  return output;
}

+ (NSUInteger)parseUInt8:(char *)data {
  return [KBKegboardMessage parseUInt32:data length:1];
}

+ (NSUInteger)parseUInt16:(char *)data {
  return [KBKegboardMessage parseUInt32:data length:2];
}

+ (NSUInteger)parseUInt32:(char *)data {
  return [KBKegboardMessage parseUInt32:data length:4];
}

+ (NSInteger)parseInt32:(char *)data {
  return (NSInteger)[KBKegboardMessage parseUInt32:data];
}

+ (double)parseTemp:(char *)data {
  NSInteger tempInteger = [KBKegboardMessage parseInt32:data];
  return ((double)tempInteger / 1000000);
}

+ (BOOL)parseBool:(char *)data {
  if (data[0] & 0xFF) return YES;
  else return NO;
}

@end

@implementation KBKegboardMessageHello
@synthesize protocolVersion=_protocolVersion;

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _protocolVersion = [KBKegboardMessage parseUInt16:data];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageHello with protocolVersion %u", _protocolVersion];
}

@end


@implementation KBKegboardMessageBoardConfiguration
@synthesize boardName=_boardName, baudRate=_baudRate, updateInterval=_updateInterval, watchdogTimeout=_watchdogTimeout;

- (void)dealloc {
  [_boardName dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _boardName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _baudRate = [KBKegboardMessage parseUInt16:data];
      break;
    case 0x03:
      _updateInterval = [KBKegboardMessage parseUInt16:data];
      break;
    case 0x04:
      _watchdogTimeout= [KBKegboardMessage parseUInt16:data];
      break;
    default:
      return NO;
  }
  return YES;
}


- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageBoardConfiguration with boardName %@ baudRate %u updateInterval %u watchdogTimeout %u", _boardName, _baudRate, _updateInterval, _watchdogTimeout];
}

@end


@implementation KBKegboardMessageMeterStatus
@synthesize meterName=_meterName, meterReading=_meterReading;

- (void)dealloc {
  [_meterName dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _meterName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _meterReading = [KBKegboardMessage parseUInt32:data];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageMeterStatus with meterName %@ _meterReading %u", _meterName, _meterReading];
}

@end


@implementation KBKegboardMessageTemperatureReading
@synthesize sensorName=_sensorName, sensorReading=_sensorReading;

- (void)dealloc {
  [_sensorName dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _sensorName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _sensorReading = [KBKegboardMessage parseTemp:data];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageTemperatureReading with _sensorName %@ _sensorReading %f", _sensorName, _sensorReading];
}

@end


@implementation KBKegboardMessageOutputStatus
@synthesize outputName=_outputName, outputReading=_outputReading;

- (void)dealloc {
  [_outputName dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _outputName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _outputReading = [KBKegboardMessage parseBool:data];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageOutputStatus with _outputName %@ _outputReading %d", _outputName, _outputReading];
}

@end


@implementation KBKegboardMessageRFID
@synthesize readerName=_readerName, tagID=_tagID;

- (void)dealloc {
  [_readerName dealloc];
  [_tagID dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _readerName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _tagID = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageRFID with _readerName %@ _tagID %@", _readerName, _tagID];
}

@end


@implementation KBKegboardMessageMagStripe
@synthesize readerName=_readerName, cardID=_cardID;
- (void)dealloc {
  [_readerName dealloc];
  [_cardID dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _readerName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _cardID = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageRFID with _readerName %@ _cardID %@", _readerName, _cardID];
}

@end
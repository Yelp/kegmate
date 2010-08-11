//
//  KBKegboard.m
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

#import "KBKegboard.h"

char *const KBSP_PREFIX = kKBSP_PREFIX;
char *const KBSP_TRAILER = kKBSP_TRAILER;

@implementation KBKegboard

@synthesize delegate=_delegate;

static NSInteger gFileDescriptor;

- (id)init {
  if ((self = [super init])) {
    if (gFileDescriptor <= 0) {
      gFileDescriptor = openPort(SERIAL_PORT, BAUD_RATE);
#if !TARGET_IPHONE_SIMULATOR
      NSAssert(gFileDescriptor != -1, @"Port failed to open");
#endif
      [self start];
    }
  }
  return self;
}

- (id)initWithDelegate:(id<KBKegboardDelegate>)delegate {
  if ((self = [self init])) {
    _delegate = delegate;
  }
  return self;
}

- (void)start {
  if (!_readLoopThread) {
    _readLoopThread = [[NSThread alloc] initWithTarget:self selector:@selector(readLoop) object:nil];
    [_readLoopThread start];
  }
}

- (void)dealloc {
  close(gFileDescriptor);
  [super dealloc];
}

- (void)notifyDelegate:(KBKegboardMessage *)message {
  NSUInteger messageId = [message messageId];
  switch (messageId) {
    case KB_MESSAGE_ID_HELLO:
      [self.delegate kegboard:self didReceiveHello:(KBKegboardMessageHello *)message];
      break;
    case KB_MESSAGE_ID_BOARD_CONFIGURATION:
      [self.delegate kegboard:self didReceiveBoardConfiguration:(KBKegboardMessageBoardConfiguration *)message];
      break;
    case KB_MESSAGE_ID_METER_STATUS:
      [self.delegate kegboard:self didReceiveMeterStatus:(KBKegboardMessageMeterStatus *)message];
      break;
    case KB_MESSAGE_ID_TEMPERATURE_READING:
      [self.delegate kegboard:self didReceiveTemperatureReading:(KBKegboardMessageTemperatureReading *)message];
      break;
    case KB_MESSAGE_ID_OUTPUT_STATUS:
      [self.delegate kegboard:self didReceiveOutputStatus:(KBKegboardMessageOutputStatus *)message];
      break;
    case KB_MESSAGE_ID_RFID:
      [self.delegate kegboard:self didReceiveRFID:(KBKegboardMessageRFID *)message];
      break;
  }
}

- (void)readLoop {
  NSLog(@"Initializing Read Loop");
  // Pool is never released since it lasts the whole life of the app
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  // Directly ported from PyKeg to ObjectiveC
  char headerBytes[4];
  char payload[KBSP_PAYLOAD_MAXLEN];
  char crc[2];
  char trailer[2];
  
  while (YES) {
    // Find the prefix, re-aligning the messages as needed.
    BOOL loggedFrameError = NO;
    NSInteger headerPosition = 0;
    while (headerPosition < KBSP_PREFIX_LENGTH) {
      char byte;
      sleeperRead(gFileDescriptor, &byte, 1);
      // Byte was expected
      if (byte == KBSP_PREFIX[headerPosition]) {
        headerPosition += 1;
        if (loggedFrameError) {
          NSLog(@"Packet framing fixed.");
          loggedFrameError = NO;
        }
      // Byte wasn't expected
      } else {
        if (!loggedFrameError) {
          NSLog(@"Packet framing broken (found \"%X\", expected \"%X\"); reframing.", byte, KBSP_PREFIX[headerPosition]);
          loggedFrameError = YES;
        }
        headerPosition = 0;
      }
    }
    
    // Read message type and message length
    sleeperRead(gFileDescriptor, headerBytes, 4);
    NSInteger messageId = [KBKegboardMessage parseUInt16:headerBytes];
    NSInteger messageLength = [KBKegboardMessage parseUInt16:&headerBytes[2]];
    if (messageLength > KBSP_PAYLOAD_MAXLEN) {
      NSLog(@"Bogus message length (%d), skipping message", messageLength);
      continue;
    }
    
    // Read payload and trailer
    sleeperRead(gFileDescriptor, payload, messageLength);
    sleeperRead(gFileDescriptor, crc, 2);
    sleeperRead(gFileDescriptor, trailer, 2);
    
    if (trailer[0] != KBSP_TRAILER[0] || trailer[1] != KBSP_TRAILER[1]) {
      NSLog(@"Bad trailer characters 0x%X 0x%X (expected 0x%X 0x%X) skipping message", trailer[0], trailer[1], KBSP_TRAILER[0], KBSP_TRAILER[1]);
      continue;
    }
    
    // TODO(johnb): Check CRC
    
    // Create KegboardMessage from id and payload
    KBKegboardMessage *kegboardMessage = [KBKegboardMessage messageWithId:messageId payload:payload length:messageLength];
    NSLog(@"Got message %@", kegboardMessage);
    // Notify delegate of message
    [self performSelectorOnMainThread:@selector(notifyDelegate:) withObject:kegboardMessage waitUntilDone:NO];
  }
  // Putting this here for symmetry and to surpress warning message
  [pool release];
}

@end


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
  }
  NSLog(@"Got unknown message with ID %d", messageId);
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
  NSAssert(0, @"Abstract Method");
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
  return ((double)tempInteger / 1000);
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
@synthesize readerName=_readerName, tagId=_tagId;

- (void)dealloc {
  [_readerName dealloc];
  [_tagId dealloc];
  [super dealloc];
}

- (BOOL)parsePayload:(char *)data forTag:(NSUInteger)tag length:(NSUInteger)length {
  switch (tag) {
    case 0x01:
      _readerName = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    case 0x02:
      _tagId = [[KBKegboardMessage parseString:data length:length] retain];
      break;
    default:
      return NO;
  }
  return YES;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"KBKegboardMessageRFID with _readerName %@ _tagId %@", _readerName, _tagId];
}

@end

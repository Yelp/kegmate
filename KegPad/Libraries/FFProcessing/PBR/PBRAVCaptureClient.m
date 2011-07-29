//
//  PBRAVCaptureClient.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRAVCaptureClient.h"
#import "PBRStreamDefines.h"
#import "PBRDefines.h"

#define MAX_MESSAGE_SIZE (200 * 1024)

@interface PBRAVCaptureClient ()
@property (retain, nonatomic) NSNetService *service;
@end

@implementation PBRAVCaptureClient

@synthesize service=_service;

- (id)init {
  if ((self = [super init])) {
    _messageData = malloc(MAX_MESSAGE_SIZE);
  }
  return self;
}

- (void)dealloc {
  [self close];
  free(_messageData);
  [_service release];
  // TODO(gabe): Who is releasing these?
  //FFVFrameRelease(_frame);
  [super dealloc];
}

- (void)close {
  _connection.delegate = nil;
  [_connection close];
  [_connection release];
  _connection = nil;
}

- (FFVFrameRef)nextFrame:(NSError **)error {  
  if (!_needsFrame) return NULL;
  _needsFrame = NO;
  return _frame;
}

- (BOOL)start:(NSError **)error { 
  // Nothing to do
  return YES;
}

- (void)connectToService:(NSNetService *)service {
  [self close];  
  self.service = service;
  if (service) {
    _connection = [[PBRConnection alloc] init];
    _connection.delegate = self;
    [_connection openWithService:service];
  }
}

- (void)reconnect {
  PBRDebug(@"Reconnecting");
  [self close];
  [self connectToService:_service];
}

- (void)receivedMessage:(uint8_t *)messageData length:(uint32_t)length {
  NSData *JPEGData = [[NSData alloc] initWithBytesNoCopy:messageData length:length freeWhenDone:NO];
  
  CGImageRef image = CGImageCreateFromJPEGData(JPEGData);
  int width = CGImageGetWidth(image);
  int height = CGImageGetHeight(image);

  if (_frame == NULL || _frame->format.width != width || _frame->format.height != height) {
    if (_frame != NULL) FFVFrameRelease(_frame);
    _frame = FFVFrameCreate(FFVFormatMake(width, height, kFFPixelFormatType_32BGRA));
    PBRDebug(@"Frame size received: %d, %d (length=%d)", width, height, length);
  }

  FFConvertFromJPEGDataToBGRA(image, _frame);
  [JPEGData release];
  _needsFrame = YES;
}

- (void)reset {
  PBRDebug(@"Resetting");
  _messageLength = 0;
  _messageIndex = 0;
}

- (void)connectionDidClose:(PBRConnection *)connection {
  [self reconnect];
}

- (void)readBytes:(uint8_t *)bytes length:(NSUInteger)length {
  if (length == 0) return;

  //PBRDebug(@"[RECV] Data, length=%d", length);
  if (length < 8) {
    PBRDebug(@"Not enough data");
    [self reset];
    return;
  }
  
  // If no message length we are at beginning of message
  if (_messageLength == 0) {
    uint32_t headerCommand;
    memcpy(&headerCommand, bytes, 4);
    memcpy(&_messageLength, bytes + 4, 4);
    bytes += 8;
    length -= 8;
    
    if (headerCommand != 0xBEEF || _messageLength > MAX_MESSAGE_SIZE) {
      PBRDebug(@"Invalid data");
      [self reset];
      return;
    }
    //PBRDebug(@"[RECV] Message: command=%X, messageLength=%d, length=%d", headerCommand, _messageLength, length);
  }
  
  if (_messageIndex + length >= _messageLength) {
    // Need to split up the data across frames
    NSUInteger lengthLeft = (_messageLength - _messageIndex);
    memcpy(_messageData + _messageIndex, bytes, lengthLeft);
    [self receivedMessage:_messageData length:_messageLength];
    _messageLength = 0;
    _messageIndex = 0;
    
    NSUInteger lengthOverflow = length - lengthLeft;
    //PBRDebug(@"[RECV] Message complete; Overflow=%d", lengthOverflow);
    NSAssert(lengthOverflow >= 0, @"No more length left");
    if (lengthOverflow > 0) {
      [self readBytes:&bytes[lengthLeft] length:lengthOverflow];
    }
  } else {
    // We got less data than was needed to fill the message data
    if ((length + _messageIndex) > MAX_MESSAGE_SIZE) {
      PBRDebug(@"Invalid data");
      [self reset];
      return;
    }
    memcpy(_messageData + _messageIndex, bytes, length);
    _messageIndex += length;
    //PBRDebug(@"[RECV] Message: %d/%d", _messageIndex, _messageLength);
  }
}

- (void)connection:(PBRConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length {
  [self readBytes:bytes length:length];
}


// Implementation for reading raw uncompressed frames
/*
 - (void)connection:(PBRConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length {
 if (_bufferIndex + length >= _frameLength) {
 // Need to split up the data across frames
 NSUInteger lengthLeft = (_frameLength - _bufferIndex);    
 memcpy(_nextFrameData + _bufferIndex, bytes, lengthLeft);
 memcpy(_frameData, _nextFrameData, _frameLength);
 
 NSUInteger lengthOverflow = length - lengthLeft;
 if (lengthOverflow > _frameLength) {
 // We have more left over than can fill a single frame. Lets discard frame(s).
 lengthOverflow = lengthOverflow % _frameLength;
 }
 
 NSAssert(lengthOverflow >= 0, @"No more length left");
 if (lengthOverflow > 0) {
 memcpy(_nextFrameData, bytes + lengthLeft, lengthOverflow);
 }
 _bufferIndex = lengthOverflow;
 _needsFrame = YES;
 } else {
 // We got less data than was needed to fill the remaining frame
 memcpy(_nextFrameData + _bufferIndex, bytes, length);
 _bufferIndex += length;
 }
 }
 */

@end

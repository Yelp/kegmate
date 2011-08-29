//
//  FFAVCaptureClient.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011. All rights reserved.
//

#import "FFAVCaptureClient.h"
#import "FFStreamDefines.h"
#import "FFUtils.h"

#define MAX_MESSAGE_SIZE (100 * 1024)


@implementation FFAVCaptureClient

- (id)init {
  if ((self = [super init])) {
    _messageData = malloc(MAX_MESSAGE_SIZE);
  }
  return self;
}

- (void)dealloc {
  [self close];
  free(_messageData);
  [super dealloc];
}

- (void)close { }

- (BOOL)connect {
  return NO;
}

- (void)reconnect {
  FFDebug(@"Reconnecting");
  [self close];
  [self connect];
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

- (void)receivedMessage:(uint8_t *)messageData length:(uint32_t)length {
  NSData *JPEGData = [[NSData alloc] initWithBytesNoCopy:messageData length:length freeWhenDone:NO];
  
  CGImageRef image = CGImageCreateFromJPEGData(JPEGData);
  int width = CGImageGetWidth(image);
  int height = CGImageGetHeight(image);

  if (_frame == NULL || _frame->format.width != width || _frame->format.height != height) {
    if (_frame != NULL) FFVFrameRelease(_frame);
    _frame = FFVFrameCreate(FFVFormatMake(width, height, kFFPixelFormatType_32BGRA));
    FFDebug(@"Frame size received: %d, %d (length=%d)", width, height, length);
  }

  FFConvertFromJPEGDataToBGRA(image, _frame);
  [JPEGData release];
  _needsFrame = YES;
}

- (void)reset {
  FFDebug(@"Resetting");
  _messageLength = 0;
  _messageIndex = 0;
  [self reconnect];
}

- (void)readBytes:(uint8_t *)bytes length:(NSUInteger)length {
  if (length == 0) return;

  //FFDebug(@"[RECV] Data, length=%d", length);
  if (length < 8 && _messageLength == 0) {
    FFDebug(@"Not enough data");
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
      FFDebug(@"Invalid data");
      [self reset];
      return;
    }
    //FFDebug(@"[RECV] Message: command=%X, messageLength=%d, length=%d", headerCommand, _messageLength, length);
  }
  
  if (_messageIndex + length >= _messageLength) {
    // Need to split up the data across frames
    NSUInteger lengthLeft = (_messageLength - _messageIndex);
    memcpy(_messageData + _messageIndex, bytes, lengthLeft);
    [self receivedMessage:_messageData length:_messageLength];
    _messageLength = 0;
    _messageIndex = 0;
    
    NSUInteger lengthOverflow = length - lengthLeft;
    //FFDebug(@"[RECV] Message complete; Overflow=%d", lengthOverflow);
    NSAssert(lengthOverflow >= 0, @"No more length left");
    if (lengthOverflow > 0) {
      [self readBytes:&bytes[lengthLeft] length:lengthOverflow];
    }
  } else {
    // We got less data than was needed to fill the message data
    if ((length + _messageIndex) > MAX_MESSAGE_SIZE) {
      FFDebug(@"Invalid data");
      [self reset];
      return;
    }
    memcpy(_messageData + _messageIndex, bytes, length);
    _messageIndex += length;
    //FFDebug(@"[RECV] Message: %d/%d", _messageIndex, _messageLength);
  }
}


// Implementation for reading raw uncompressed frames
/*
 - (void)connection:(FFConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length {
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

//
//  FFConnection.m
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "FFConnection.h"
#import "FFUtils.h"
#import "FFStreamUtils.h"


@interface FFConnection ()
@property (retain, nonatomic) NSString *serviceName;
- (void)_close;
@end


@implementation FFConnection

@synthesize output=_output, input=_input, delegate=_delegate, serviceName=_serviceName;

- (id)init {
  if ((self = [super init])) {
    _readBufferSize = 32 * 1024;

    // Messages
    _headerCommand = 0xBEEF;
    _headerBuffer = malloc(8);
  }
  return self;
}

- (void)dealloc {
  [self _close];
  [_serviceName release];
  if (_readBuffer != NULL) free(_readBuffer);
  [_message release];
  if (_headerBuffer != NULL) free(_headerBuffer);
  [super dealloc];
}

- (void)_openStreams {
  _input.delegate = self;
  [_input scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  [_input open];
  
  _output.delegate = self;
  [_output scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  [_output open];
}  

- (BOOL)openWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream {
  [self _close];
  self.input = inputStream;
  self.output = outputStream;
  [self _openStreams];
  return YES;
}

- (BOOL)openWithService:(NSNetService *)service {
  [self _close];
  self.serviceName = service.name;
  BOOL success = [service getInputStream:&_input outputStream:&_output];
  FFDebug(@"Open net service: %d (%@)", success, service);
  if (success) {    
    [self _openStreams];
    return YES;
  }
  FFDebug(@"Failed to open net service");
  return NO;
}

- (BOOL)openWithName:(NSString *)name ipAddress:(NSString *)ipAddress port:(SInt32)port {
  [self _close];
  self.serviceName = name;
  NSData *address = [FFStreamUtils dataForIPAddress:ipAddress];
  
  CFHostRef host = CFHostCreateWithAddress(NULL, (CFDataRef)address);
  CFReadStreamRef readStream;
  CFWriteStreamRef writeStream;
  CFStreamCreatePairWithSocketToCFHost(NULL, host, port, &readStream, &writeStream);
  _input = (NSInputStream *)readStream;
  _output = (NSOutputStream *)writeStream;
  if (_input && _output) {
    [self _openStreams];
    return YES;
  }
  return NO;
}

- (void)_close {
  FFDebug(@"Closing connection");
  _input.delegate = nil;
  [_input close];
  [_input removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  [_input release];
  _input = nil;
  
  _output.delegate = nil;
  [_output close];
  [_output removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
  [_output release];
  _output = nil;
  
  self.serviceName = nil;
}

- (void)close {
  [self _close];
  [_delegate connectionDidClose:self];
}

- (NSInteger)writeBytes:(uint8_t *)bytes length:(NSUInteger)length {
  if (!_output) { 
    //FFDebug(@"No output");
    return -1; 
  }
  if (![_output hasSpaceAvailable]) {
    //FFDebug(@"No space available");
    return -2;
  }
  NSUInteger bytesToWrite = length;
  NSInteger bytesTotalWritten = 0;
  do {
    //FFDebug(@"Writing bytes (%d)", bytesToWrite);
    if (![_output hasSpaceAvailable]) break;
    NSInteger bytesWritten = [_output write:&bytes[bytesTotalWritten] maxLength:bytesToWrite];
    if (bytesWritten > 0) {
      bytesToWrite -= bytesWritten;
      bytesTotalWritten += bytesWritten;
    } else {
      break;
    } 
  } while (bytesToWrite > 0);
  //FFDebug(@"Wrote %d", bytesTotalWritten);
  return bytesTotalWritten;
}

- (void)read {
  if (_readBuffer == NULL) {
    _readBuffer = calloc(1, _readBufferSize);
  }
  
  if (![_input hasBytesAvailable]) return;
    
  NSInteger bytesRead = [_input read:_readBuffer maxLength:_readBufferSize];
  //FFDebug(@"bytesRead=%d", bytesRead);
  if (bytesRead > 0) {
    [_delegate connection:self didReadBytes:_readBuffer length:bytesRead];
  } else if (bytesRead < 0) {
    FFDebug(@"Error on read: %d", bytesRead);
    [self close];
  }
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
  switch(eventCode) {
    case NSStreamEventOpenCompleted: {
      FFDebug(@"Connection open completed");
      break;
    }
    case NSStreamEventHasSpaceAvailable: {
      //FFDebug(@"Has space (available for write)");
      break;
    }
    case NSStreamEventHasBytesAvailable: {
      //FFDebug(@"Has bytes (for read)");
      [self read];
      break;
    }
    case NSStreamEventErrorOccurred: {
      FFDebug(@"Connection error: %@", [[stream streamError] gh_fullDescription]);
      [self close];
      break;
    }
    case NSStreamEventEndEncountered: {
      FFDebug(@"Connection end");
      [self close];
      break;
    }
  }
}

#pragma mark -

// Send message; We will NOT send this if we are in the middle of sending the last message.
- (BOOL)writeMessage:(NSData *)message {
  // Implementation if we can send different parts of different
  // frames (we are sending raw frames).
  /*
   FFVFrameRef frame = [_reader nextFrame:nil];
   if (frame != NULL) {    
   uint8_t *data = FFVFrameGetData(frame, 0);
   NSInteger length = _frameLength;
   NSInteger index = 0;
   // Check if we weren't able to send a full frame last time,
   // and if not lets send the remaining part but from this next
   // frame.
   if (_frameLengthSent > 0 && _frameLengthSent < _frameLength) {
   length = _frameLength - _frameLengthSent;
   index = _frameLengthSent;
   }
   NSInteger lengthSent = [self writeBytes:&data[index] length:length];
   if (lengthSent > 0) {
   _frameLengthSent = lengthSent + index;
   }
   }*/
  
  // If we already have part of a message to send lets skip this one
  if (_message) return NO;
  
  if (!_message) {
    _message = [message retain];
    uint32_t messageLength = (uint32_t)[_message length];
    memcpy(_headerBuffer, &_headerCommand, 4);
    memcpy(_headerBuffer + 4, &messageLength, 4);
    NSInteger headerLengthSent = [self writeBytes:_headerBuffer length:8];
    if (headerLengthSent <= 0) return NO;
  }

  if (_message) {
    uint8_t *data = (uint8_t *)[_message bytes];
    NSInteger lengthSent = [self writeBytes:&data[_messageIndex] length:([_message length] - _messageIndex)];
    if (lengthSent > 0) {
      _messageIndex += lengthSent;
      //FFDebug(@"[SEND] Message complete: %d", [_messageData length]);
      NSAssert(lengthSent <= [_message length], @"Sent more than we had?");
      if (lengthSent == [_message length]) {
        [_message release];
        _message = nil;
        _messageIndex = 0;
      }
    }
  }
  return YES;
}

@end

//
//  FFAVCaptureClient.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011. All rights reserved.
//

#import "FFReader.h"


@interface FFAVCaptureClient : NSObject <FFReader> {
  
  FFVFrameRef _frame;
  uint8_t *_frameData;
  BOOL _needsFrame;

  NSUInteger _messageIndex;
  uint32_t _messageLength;
  uint8_t *_messageData;
}

- (void)readBytes:(uint8_t *)bytes length:(NSUInteger)length;

- (void)close;

- (BOOL)connect;

- (void)reconnect;

@end

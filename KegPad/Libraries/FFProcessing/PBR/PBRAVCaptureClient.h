//
//  PBRAVCaptureClient.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FFReader.h"
#import "PBRConnection.h"


@interface PBRAVCaptureClient : NSObject <FFReader, PBRConnectionDelegate> {
  
  NSNetService *_service;
  PBRConnection *_connection;
  
  FFVFrameRef _frame;
  uint8_t *_frameData;
  BOOL _needsFrame;

  NSUInteger _messageIndex;
  uint32_t _messageLength;
  uint8_t *_messageData;
}

- (void)connectToService:(NSNetService *)netService;

@end

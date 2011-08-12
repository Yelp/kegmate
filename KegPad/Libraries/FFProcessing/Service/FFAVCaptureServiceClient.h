//
//  FFAVCaptureServiceClient.h
//  KegPad
//
//  Created by Gabriel Handford on 8/8/11.
//  Copyright 2011. All rights reserved.
//

#import "FFAVCaptureClient.h"
#import "FFConnection.h"

@interface FFAVCaptureServiceClient : FFAVCaptureClient <FFConnectionDelegate> {
  FFConnection *_connection;
  
  NSNetService *_service;
}

- (id)initWithService:(NSNetService *)service;

@end

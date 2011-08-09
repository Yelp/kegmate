//
//  PBRAVCaptureServiceClient.h
//  KegPad
//
//  Created by Gabriel Handford on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRAVCaptureClient.h"
#import "PBRConnection.h"

@interface PBRAVCaptureServiceClient : PBRAVCaptureClient <PBRConnectionDelegate> {
  PBRConnection *_connection;
  
  NSNetService *_service;
}

- (id)initWithService:(NSNetService *)service;

@end

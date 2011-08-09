//
//  PBRAVCaptureRemoteClient.h
//  KegPad
//
//  Created by Gabriel Handford on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRAVCaptureClient.h"
#import "PBRConnection.h"
#import "KBKegTimeHost.h"

@interface PBRAVCaptureRemoteClient : PBRAVCaptureClient <PBRConnectionDelegate> {
  PBRConnection *_connection;
  KBKegTimeHost *_host;
}

- (id)initWithHost:(KBKegTimeHost *)host;

@end


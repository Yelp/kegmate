//
//  FFAVCaptureRemoteClient.h
//  KegPad
//
//  Created by Gabriel Handford on 8/8/11.
//  Copyright 2011. All rights reserved.
//

#import "FFAVCaptureClient.h"
#import "FFConnection.h"
#import "KBKegTimeHost.h"

@interface FFAVCaptureRemoteClient : FFAVCaptureClient <FFConnectionDelegate> {
  FFConnection *_connection;
  KBKegTimeHost *_host;
}

- (id)initWithHost:(KBKegTimeHost *)host;

@end


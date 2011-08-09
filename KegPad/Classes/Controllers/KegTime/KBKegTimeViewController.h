//
//  KBKegTimeViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FFReaderView.h"
#import "PBRAVCaptureClient.h"
#import "FFAVCaptureSessionReader.h"
#import "KBKegTimeHost.h"

@interface KBKegTimeViewController : UIViewController {
  PBRAVCaptureClient *videoServer_;
  FFReaderView *videoView_;
  
  CGSize _videoSize;
  
  FFAVCaptureSessionReader *videoCapture_;
}

@property (assign, nonatomic) CGSize videoSize;

- (void)enableCamera;

- (void)close;

- (void)connectToService:(NSNetService *)service;

- (void)connectToHost:(KBKegTimeHost *)host;

@end

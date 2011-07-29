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

@interface KBKegTimeViewController : UIViewController {
  PBRAVCaptureClient *videoServer_;
  FFReaderView *videoView_;
  
  FFAVCaptureSessionReader *videoCapture_;
}

- (void)enableCamera;

- (void)close;

- (void)setNetService:(NSNetService *)netService;

@end

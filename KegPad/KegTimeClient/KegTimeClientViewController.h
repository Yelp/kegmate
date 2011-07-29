//
//  KegTimeClientViewController.h
//  KegTimeClient
//
//  Created by Gabriel Handford on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRAVCaptureClient.h"
#import "FFReaderView.h"

@interface KegTimeClientViewController : UIViewController {
  PBRAVCaptureClient *videoServer_;
  FFReaderView *videoView_;
}

- (void)enableCamera;

- (void)setNetService:(NSNetService *)netService;

@end

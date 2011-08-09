//
//  KBKegTimeViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBKegTimeViewController.h"
#import "PBRAVCaptureServiceClient.h"
#import "PBRAVCaptureRemoteClient.h"
#import "FFAVCaptureSessionReader.h"


@implementation KBKegTimeViewController

@synthesize videoSize=_videoSize;

- (id)init {
  if ((self = [super init])) {
    self.title = @"KegTime";
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    _videoSize = CGSizeZero;
  }
  return self;
}

- (void)dealloc {
  [self close];
  [videoView_ release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  if (_videoSize.width == 0) _videoSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
  
  if (!videoView_) {
    videoView_ = [[FFReaderView alloc] initWithFrame:CGRectMake(0, 0, _videoSize.width, _videoSize.height)];
  }
  [self.view addSubview:videoView_];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self close];
}

- (void)close {
  self.title = @"KegTime";
  [videoCapture_ close];
  [videoCapture_ release];
  videoCapture_ = nil;  
  [videoServer_ close];
  [videoServer_ release];
  videoServer_ = nil;  
}

- (void)setReader:(id<FFReader>)reader {
  [self view];
  [videoView_ setReader:reader];
  [videoView_ startAnimation];
}

- (void)enableCamera {
  [videoCapture_ close];
  [videoCapture_ release];
  videoCapture_ = nil;  
  videoCapture_ = [[FFAVCaptureSessionReader alloc] init];
  [videoCapture_ start:nil];
  [self setReader:videoCapture_];
}

- (void)connectToService:(NSNetService *)service {  
  [self close];
  if (service) {
    if (service.name) {
      self.title = [NSString stringWithFormat:@"KegTime: %@", service.name];  
    }
    videoServer_ = [[PBRAVCaptureServiceClient alloc] initWithService:service];
    [videoServer_ connect];
    [self setReader:videoServer_];
  }
}

- (void)connectToHost:(KBKegTimeHost *)host {
  if (host.name) {
    self.title = [NSString stringWithFormat:@"KegTime: %@", host.name];  
  }
  videoServer_ = [[PBRAVCaptureRemoteClient alloc] initWithHost:host];
  [videoServer_ connect];
  [self setReader:videoServer_];
}

@end

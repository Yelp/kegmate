//
//  KBKegTimeViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBKegTimeViewController.h"
#import "PBRAVCaptureClient.h"
#import "FFAVCaptureSessionReader.h"


@implementation KBKegTimeViewController

- (id)init {
  if ((self = [super init])) {
    self.title = @"KegTime";
    self.modalPresentationStyle = UIModalPresentationFormSheet;
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
  videoView_ = [[FFReaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
  [self.view addSubview:videoView_];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self close];
}

- (void)close {
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

- (void)setNetService:(NSNetService *)netService {  
  self.title = @"KegTime";
  [videoServer_ close];
  [videoServer_ release];
  videoServer_ = nil;  
  if (netService) {
    if (netService.name) {
      self.title = [NSString stringWithFormat:@"KegTime: %@", netService.name];  
    }
    videoServer_ = [[PBRAVCaptureClient alloc] init];
    //[videoServer_ start:nil];
    [videoServer_ connectToService:netService];
    [self setReader:videoServer_];
  }
}

@end

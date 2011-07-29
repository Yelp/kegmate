//
//  KegTimeClientViewController.m
//  KegTimeClient
//
//  Created by Gabriel Handford on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KegTimeClientViewController.h"

#import "FFAVCaptureSessionReader.h"


@implementation KegTimeClientViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  videoView_ = [[FFReaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  [self.view addSubview:videoView_];
}

- (void)setReader:(id<FFReader>)reader {
  [self view];
  [videoView_ setReader:reader];
  [videoView_ startAnimation];
}

- (void)enableCamera {
  FFAVCaptureSessionReader *reader = [[FFAVCaptureSessionReader alloc] init];
  [reader start:nil];
  [self setReader:reader];
  [reader release];
}

- (void)setNetService:(NSNetService *)netService {
  self.title = [NSString stringWithFormat:@"KegTime: %@", netService.name];  
  PBRAVCaptureClient *videoServer = [[PBRAVCaptureClient alloc] init];
  [videoServer start:nil];
  [videoServer connectToService:netService];
  [self setReader:videoServer];
  [videoServer release];
}

@end

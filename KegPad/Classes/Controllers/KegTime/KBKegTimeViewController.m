//
//  KBKegTimeViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2010 Yelp. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "KBKegTimeViewController.h"
#import "FFAVCaptureServiceClient.h"
#import "FFAVCaptureRemoteClient.h"
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

- (void)loadView {
  [videoView_ release];
  videoView_ = [[FFReaderView alloc] init];
  videoView_.videoFrameSize = CGSizeMake(144, 192); // TODO(gabe): Get this from the reader
  self.view = videoView_;
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
    videoServer_ = [[FFAVCaptureServiceClient alloc] initWithService:service];
    [videoServer_ connect];
    [self setReader:videoServer_];
  }
}

- (void)connectToHost:(KBKegTimeHost *)host {
  if (host.name) {
    self.title = [NSString stringWithFormat:@"KegTime: %@", host.name];  
  }
  videoServer_ = [[FFAVCaptureRemoteClient alloc] initWithHost:host];
  [videoServer_ connect];
  [self setReader:videoServer_];
}

@end

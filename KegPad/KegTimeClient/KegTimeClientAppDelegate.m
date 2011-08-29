//
//  KegTimeClientAppDelegate.m
//  KegTimeClient
//
//  Created by Gabriel Handford on 7/29/11.
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

#import "KegTimeClientAppDelegate.h"
#import "FFAVCaptureService.h"

@implementation KegTimeClientAppDelegate

@synthesize window=_window;

- (void)dealloc {
  [_window release];
  [_viewController release];
  [_dataStore release];
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  //[application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  _viewController = [[KBKegTimeSearchNavigationController alloc] init];
  _viewController.kegTimeSearchViewController.navigationItem.leftBarButtonItem = nil;
  _viewController.navigationBar.tintColor = [UIColor blackColor];

  [self.window addSubview:_viewController.view];
  [self.window makeKeyAndVisible];
  
  
  // Start video server
  /*
  if ([FFAVCaptureService isSupported]) {
    captureService_ = [[FFAVCaptureService alloc] init];
    [captureService_ start:nil];
    [captureService_ enableBonjourWithDomain:@"local." serviceType:@"_kegtime._tcp." name:nil];
  }
  */
  return YES;
}

- (FFAVCaptureService *)captureService {
  return captureService_;
}

- (KBDataStore *)dataStore {
  if (!_dataStore) _dataStore = [[KBDataStore alloc] init];
  return _dataStore;
}

- (void)applicationWillResignActive:(UIApplication *)application { }

- (void)applicationDidEnterBackground:(UIApplication *)application { }

- (void)applicationWillEnterForeground:(UIApplication *)application { }

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application { }

@end

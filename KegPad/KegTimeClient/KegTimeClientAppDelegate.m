//
//  KegTimeClientAppDelegate.m
//  KegTimeClient
//
//  Created by Gabriel Handford on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KegTimeClientAppDelegate.h"

@implementation KegTimeClientAppDelegate

@synthesize window=_window;

- (void)dealloc {
  [_window release];
  [_viewController release];
  [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
  _viewController = [[KBKegTimeSearchNavigationController alloc] init];
  _viewController.kegTimeSearchViewController.navigationItem.leftBarButtonItem = nil;
  _viewController.navigationBar.tintColor = [UIColor blackColor];

  [self.window addSubview:_viewController.view];
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }

- (void)applicationDidEnterBackground:(UIApplication *)application { }

- (void)applicationWillEnterForeground:(UIApplication *)application { }

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application { }

@end

//
//  KBApplicationDelegate.m
//  KegPad
//
//  Created by Gabriel Handford on 7/28/10.
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

#import "KBApplicationDelegate.h"

#import "KBNotifications.h"
#import "KBDataImporter.h"

@implementation KBApplicationDelegate

@synthesize window=window_, kegProcessor=kegProcessor_;

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [store_ release];
  [window_ release];
  [displayViewController_ release];
  [statusViewController_ release];
  [navigationController_ release];
  [super dealloc];
}

- (void)popPushViewController:(UIViewController *)viewController {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1.0];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navigationController_.view cache:NO];  
  [navigationController_ popViewControllerAnimated:NO];
  if (![[navigationController_ viewControllers] containsObject:viewController])
    [navigationController_ pushViewController:viewController animated:NO];  
  [UIView commitAnimations]; 
}

- (void)_swapScreens:(NSNotification *)notification {
  if (![[navigationController_ viewControllers] containsObject:statusViewController_]) {
    [self popPushViewController:statusViewController_];
  } else {
    [self popPushViewController:displayViewController_];
  }
}

- (void)initializeSounds {
  // Initialize 'glass' sound
  NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Glass" ofType:@"aiff"];
  CFURLRef soundURL = (CFURLRef)[NSURL fileURLWithPath:soundPath];
  AudioServicesCreateSystemSoundID(soundURL, &systemSounds_[0]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
  [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

  displayViewController_ = [[KBDisplayViewController alloc] init];
  
  statusViewController_ = [[KBStatusViewController alloc] init];

  navigationController_ = [[UINavigationController alloc] initWithRootViewController:displayViewController_];
  navigationController_.navigationBarHidden = YES;
  [window_ addSubview:[navigationController_ view]];
  [window_ makeKeyAndVisible];
    
  [self initializeSounds];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegSelectionDidChange:) name:KBKegSelectionDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_swapScreens:) name:KBSwapScreensNotification object:nil];      
  
  kegProcessor_ = [[KBKegProcessor alloc] init];

  // Manual importing of data; Temporary until we build out admin section
  [KBDataImporter updateDataStore:kegProcessor_.dataStore];

  // Set the keg (only 1 keg is currently supported)
  KBKeg *keg = [kegProcessor_.dataStore kegAtPosition:0];
  [self setKeg:keg];
  
  // Start processing
  [kegProcessor_ start];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }
- (void)applicationDidBecomeActive:(UIApplication *)application { }
- (void)applicationWillTerminate:(UIApplication *)application { }

- (void)playSystemSoundGlass {
  AudioServicesPlaySystemSound(systemSounds_[0]);
}

- (void)setKeg:(KBKeg *)keg {
  displayViewController_.view;
  statusViewController_.view;
  
  [displayViewController_ updateKeg:keg];
  [displayViewController_ updateRecentPours];
  [displayViewController_ setKegTemperature:nil]; // TODO(gabe): Load last temperature
  
  [statusViewController_ updateKeg:keg];
  [statusViewController_ setLastKegPour:[[KBApplication dataStore] lastPour:nil]];  
  [statusViewController_ setKegTemperature:nil]; // TODO(gabe): Load last temperature
  [statusViewController_ updateLeaderboard];  
  [statusViewController_ updateChart];
}

- (void)_kegSelectionDidChange:(NSNotification *)notification {
  [self setKeg:[notification object]];
}

@end


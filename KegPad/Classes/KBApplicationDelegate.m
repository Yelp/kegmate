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
#import "KBUserEditViewController.h"

@implementation KBApplicationDelegate

@synthesize window=window_, kegProcessor=kegProcessor_;

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [store_ release];
  [window_ release];
  displayViewController_.delegate = nil;
  [displayViewController_ release];
  statusViewController_.delegate = nil;
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

- (void)flip {
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
  displayViewController_.delegate = self;
  
  statusViewController_ = [[KBStatusViewController alloc] init];
  statusViewController_.delegate = self;

  navigationController_ = [[UINavigationController alloc] initWithRootViewController:displayViewController_];
  navigationController_.navigationBarHidden = YES;
  [window_ addSubview:[navigationController_ view]];
  [window_ makeKeyAndVisible];
    
  [self initializeSounds];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegSelectionDidChange:) name:KBKegSelectionDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userDidLogin:) name:KBUserDidLoginNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userDidLogout:) name:KBUserDidLogoutNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_unknowTagId:) name:KBUnknownTagIdNotification object:nil];  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editUser:) name:KBEditUserNotification object:nil];    
  
  kegProcessor_ = [[KBKegProcessor alloc] init];

  // Manual importing of data; Temporary until we build out admin section
  [KBDataImporter updateDataStore:kegProcessor_.dataStore];

  // Set the keg (only 1 keg is currently supported)
  KBKeg *keg = [kegProcessor_.dataStore kegAtPosition:0];
  [self setKeg:keg];
  
  // Start processing
  [kegProcessor_ start];

  // For testing unknown tag sign up flow
  //[self performSelector:@selector(_testUnknownTag) withObject:nil afterDelay:1.0];
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

- (void)setUser:(KBUser *)user {
  [displayViewController_ setUser:user];
}

- (void)signUpTagId:(NSString *)tagId {
  KBUserAddNavigationController *userAddNavigationController = [[KBUserAddNavigationController alloc] init];
  userAddNavigationController.userEditViewController.delegate = self;
  [userAddNavigationController.userEditViewController setTagId:tagId editable:NO];
  [navigationController_ presentModalViewController:userAddNavigationController animated:YES];
  [userAddNavigationController release];
}

- (void)editUser:(KBUser *)user {
  KBUserAddNavigationController *userAddNavigationController = [[KBUserAddNavigationController alloc] init];
  userAddNavigationController.userEditViewController.delegate = self;
  [userAddNavigationController.userEditViewController setUser:user];
  [navigationController_ presentModalViewController:userAddNavigationController animated:YES];
  [userAddNavigationController release];
}

#pragma mark Notifications

- (void)_kegSelectionDidChange:(NSNotification *)notification {
  [self setKeg:[notification object]];
}

- (void)_userDidLogin:(NSNotification *)notification {
  [self setUser:[notification object]];
}

- (void)_userDidLogout:(NSNotification *)notification {
  [self setUser:nil];
}

- (void)_editUser:(NSNotification *)notification {
  [self editUser:[notification object]];
}

- (void)_unknowTagId:(NSNotification *)notification {
  [self signUpTagId:[notification object]];
}

#pragma mark KBUserEditViewControllerDelegate

- (void)userEditViewController:(KBUserEditViewController *)userEditViewController didAddUser:(KBUser *)user {
  [[KBApplication kegProcessor] login:user];
  [[KBApplication sharedDelegate] playSystemSoundGlass]; // TODO(gabe): Special welcome sound effect
  [navigationController_ dismissModalViewControllerAnimated:YES];
}

#pragma mark Testing

- (void)_testUnknownTag {
  // For testing
  srand(time(NULL));
  NSString *randomTagId = [NSString stringWithFormat:@"%d", [NSNumber gh_randomInteger]];
  [kegProcessor_ kegProcessing:kegProcessor_.processing didReceiveRFIDTagId:randomTagId];
}

@end


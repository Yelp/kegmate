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

@synthesize window=window_, kegManager=kegManager_, twitterShare=twitterShare_, captureService=captureService_;

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [captureService_ release];
  [twitterShare_ release];
  [kegManager_ release];
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
  animating_ = YES;
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:1.0];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(_popPushDidStop)];
  [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:navigationController_.view cache:NO];  
  [navigationController_ popViewControllerAnimated:NO];
  if (![[navigationController_ viewControllers] containsObject:viewController])
    [navigationController_ pushViewController:viewController animated:NO];  
  [UIView commitAnimations];
}

- (void)_popPushDidStop {
  animating_ = NO;
}

- (BOOL)flip {
  if (animating_) return NO;
  
  if (![[navigationController_ viewControllers] containsObject:statusViewController_]) {
    [self popPushViewController:statusViewController_];
  } else {
    [self popPushViewController:displayViewController_];
  }
  return YES;
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_unknownTagId:) name:KBUnknownTagIdNotification object:nil];  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_selectUser:) name:KBDidSelectUserNotification object:nil];    
  
  kegManager_ = [[KBKegManager alloc] init];
  
  twitterShare_ = [[KBTwitterShare alloc] init];

  // Set the keg (only 1 keg is currently supported)
  KBKeg *keg = [kegManager_.dataStore kegAtPosition:0];
  if (keg) {
    [self setKeg:keg];
  }
  
  // Setup some defaults
  [[KBApplication dataStore] addOrUpdateUserWithTagId:@"ADMIN" firstName:@"Yelp" lastName:@"Admin" isAdmin:YES error:nil];
  
  // Start processing
  [kegManager_ start];
  
  // Start video server
  if ([PBRAVCaptureService isSupported]) {
    captureService_ = [[PBRAVCaptureService alloc] init];
    [captureService_ start:nil];
    [captureService_ enableBonjourWithName:nil];
  }
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application { }
- (void)applicationDidBecomeActive:(UIApplication *)application { }
- (void)applicationWillTerminate:(UIApplication *)application { }

- (void)playSystemSoundGlass {
  AudioServicesPlaySystemSound(systemSounds_[0]);
}

- (void)setKeg:(KBKeg *)keg {
  [displayViewController_ view];
  [statusViewController_ view];
  
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

- (void)registerTagId:(NSString *)tagId {
  KBUserEditNavigationController *userEditNavigationController = [[KBUserEditNavigationController alloc] initWithTitle:@"Sign Up" buttonTitle:@"Sign Up"];
  userEditNavigationController.userEditViewController.delegate = self;
  [userEditNavigationController.userEditViewController setTagId:tagId editable:NO];
  [navigationController_ presentModalViewController:userEditNavigationController animated:YES];
  [userEditNavigationController release];
}

- (void)editUser:(KBUser *)user {
  KBUserEditNavigationController *userEditNavigationController = [[KBUserEditNavigationController alloc] initWithTitle:@"Edit" buttonTitle:@"Save"];
  userEditNavigationController.userEditViewController.delegate = self;
  [userEditNavigationController.userEditViewController setUser:user];
  [navigationController_ presentModalViewController:userEditNavigationController animated:YES];
  [userEditNavigationController release];
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

- (void)_selectUser:(NSNotification *)notification {
  [self editUser:[notification object]];
}

- (void)_unknownTagId:(NSNotification *)notification {
  [self registerTagId:[notification object]];
  [[KBApplication sharedDelegate] playSystemSoundGlass];
}

#pragma mark KBUserEditViewControllerDelegate

- (void)userEditViewController:(KBUserEditViewController *)userEditViewController didSaveUser:(KBUser *)user {
  [[KBApplication kegManager] login:user];
  [[KBApplication sharedDelegate] playSystemSoundGlass]; // TODO(gabe): Special welcome sound effect
  [navigationController_ dismissModalViewControllerAnimated:YES];
}

- (void)userEditViewControllerDidLogout:(KBUserEditViewController *)userEditViewController {
  [navigationController_ dismissModalViewControllerAnimated:YES];
}

#pragma mark Testing

- (void)_testUnknownTag {
  // For testing
  srand(time(NULL));
  NSString *randomTagId = [NSString stringWithFormat:@"%d", [NSNumber gh_randomInteger]];
  [kegManager_ kegProcessing:kegManager_.processing didReceiveRFIDTagId:randomTagId];
}

@end


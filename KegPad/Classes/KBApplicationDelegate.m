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

#import <RestKit/RestKit.h>
#import "KBApplicationDelegate.h"
#import "KBNotifications.h"
#import "KBDataImporter.h"
#import "KBUserEditViewController.h"
#import "KBRKKeg.h"
#import "KBRKBeerType.h"
#import "KBRKUser.h"
#import "KBRKDrink.h"

@implementation KBApplicationDelegate

@synthesize window=window_, kegManager=kegManager_, twitterShare=twitterShare_;

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

- (void)initializeRestKit {
  // Initialize RestKit
  // TODO(johnb): Make the host configurable
  RKObjectManager* objectManager = [RKObjectManager objectManagerWithBaseURL:@"http://people.yelpcorp.com:16001/api"];

  // Enable automatic network activity indicator management
  [RKRequestQueue sharedQueue].showsNetworkActivityIndicatorWhenBusy = YES;
  
  RKObjectMapping *kegMapping = [RKObjectMapping mappingForClass:[KBRKKeg class]];
  [kegMapping mapKeyPathsToAttributes:@"id", @"identifier",
   @"type_id", @"typeId",
   @"size_id", @"sizeId",
   @"size_name", @"sizeName",
   @"size_volume_ml", @"sizeVolumeMl",
   @"volume_ml_remain", @"volumeMlRemain",
   @"percent_full", @"percentFull",
   @"started_time", @"startedTime",
   @"finished_time", @"finishedTime",
   @"status", @"status",
   @"description", @"descriptionText",
   @"spilled_ml", @"spilledMl",
   nil];
  [kegMapping.dateFormatStrings addObject:@"y-MM-dTHH:mm:ssZ"];
  // Add our element to object mappings
  [objectManager.mappingProvider registerMapping:kegMapping withRootKeyPath:@"result.kegs"];

  RKObjectMapping *beerTypeMapping = [RKObjectMapping mappingForClass:[KBRKBeerType class]];
  [beerTypeMapping mapKeyPathsToAttributes:
  @"id", @"identifier",
  @"name", @"name",
   nil];
  [objectManager.mappingProvider registerMapping:beerTypeMapping withRootKeyPath:@"result.beer_types"];

  RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[KBRKUser class]];
  [userMapping mapKeyPathsToAttributes:
   @"username", @"username",
   @"mugshot_url", @"mugshotUrl",
   @"is_active", @"isActive",
   nil];
  [objectManager.mappingProvider registerMapping:userMapping withRootKeyPath:@"result.users"];

  RKObjectMapping *drinkMapping = [RKObjectMapping mappingForClass:[KBRKDrink class]];
  [drinkMapping mapKeyPathsToAttributes:
   @"id", @"identifier",
   @"ticks", @"ticks",
   @"volume_ml", @"volumeMl",
   @"session_id", @"sessionId",
   @"pour_time", @"pourTime",
   @"duration", @"duration",
   @"status", @"status",
   @"keg_id", @"kegId",
   @"user_id", @"userId",
   @"auth_token_id", @"authTokenId",
   nil];
  [objectManager.mappingProvider registerMapping:drinkMapping withRootKeyPath:@"result.drinks"];

  // Set Up Router
	// The router is responsible for generating the appropriate resource path to
	// GET/POST/PUT/DELETE an object representation. This prevents your code from
	// becoming littered with identical resource paths as you manipulate common 
	// objects across your application. Note that a single object representation
	// can be loaded from any number of resource paths. You can also PUT/POST
	// an object to arbitrary paths by configuring the object loader yourself. The
	// router is just for configuring the default 'home address' for an object.
	[objectManager.router routeClass:[KBRKKeg class] toResourcePath:@"/kegs/(identifier)" forMethod:RKRequestMethodGET];
	[objectManager.router routeClass:[KBRKKeg class] toResourcePath:@"/kegs/(identifier)" forMethod:RKRequestMethodPUT];
	[objectManager.router routeClass:[KBRKKeg class] toResourcePath:@"/kegs/(identifier)" forMethod:RKRequestMethodDELETE];
  /*
   RKManagedObjectSeeder* seeder = [RKManagedObjectSeeder objectSeederWithObjectManager:objectManager];
   // Seed the database with instances of RKTStatus from a snapshot of the RestKit Twitter timeline
   [seeder seedObjectsFromFile:@"rk_kegs.json" toClass:[KBRKKeg class] keyPath:@"result.kegs"];
   
   // Finalize the seeding operation and output a helpful informational message
   [seeder finalizeSeedingAndExit];
*/
  
  // Initialize object store
  //objectManager.objectStore = [RKManagedObjectStore objectStoreWithStoreFilename:@"RKKegPad.sqlite" usingSeedDatabaseName:nil managedObjectModel:nil delegate:nil];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  
  [self initializeRestKit];

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


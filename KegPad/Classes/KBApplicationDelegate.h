//
//  KBApplicationDelegate.h
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

#import "KBDisplayViewController.h"
#import "KBStatusViewController.h"
#import "KBUserEditViewController.h"
#import "KBKegManager.h"
#import "KBApplication.h"
#import <AudioToolbox/AudioServices.h>
#import "PBRAVCaptureService.h"

/*!
 Main application delegate.
 */
@interface KBApplicationDelegate : NSObject <KBApplicationDelegate, KBUserEditViewControllerDelegate> {
  UIWindow *window_;    
  
  KBDataStore *store_;

  UINavigationController *navigationController_;
  KBDisplayViewController *displayViewController_;
  KBStatusViewController *statusViewController_;
  
  SystemSoundID systemSounds_[1];
  
  KBKegManager *kegManager_;
  KBTwitterShare *twitterShare_;
  
  PBRAVCaptureService *videoServer_;
  
  BOOL animating_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly) KBKegManager *kegManager;
@property (nonatomic, readonly) KBTwitterShare *twitterShare;

- (void)setKeg:(KBKeg *)keg;

- (BOOL)flip;

@end


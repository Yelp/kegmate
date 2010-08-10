//
//  KBKegBotApplicationDelegate.h
//  KegBot
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
#import "KBKegProcessor.h"
#import "KBKegBotApplication.h"
#import <AudioToolbox/AudioServices.h>

/*!
 Main application delegate.
 */
@interface KBKegBotApplicationDelegate : NSObject <KBKegBotApplicationDelegate> {    
  UIWindow *window_;    
  
  KBDataStore *store_;

  UINavigationController *navigationController_;
  KBDisplayViewController *displayViewController_;
  KBStatusViewController *statusViewController_;
  
  SystemSoundID systemSounds_[1];
  
  KBKegProcessor *kegProcessor_;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, readonly) KBKegProcessor *kegProcessor;

- (void)setKeg:(KBKeg *)keg;

@end


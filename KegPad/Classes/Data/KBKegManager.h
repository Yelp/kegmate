//
//  KBKegManager.h
//  KegPad
//
//  Created by Gabriel Handford on 8/9/10.
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

#import "KBKegProcessing.h"
#import "KBUser.h"
#import "KBDataStore.h"

/*!
 Interfaces to keg processing (may multiple in the future) and the data store; Keeps track of current user, pouring status,
 and triggering all the notifications.
 */
@interface KBKegManager : NSObject <KBKegProcessingDelegate, RKObjectLoaderDelegate> {

  KBUser *loginUser_;
  NSTimeInterval activityTime_; // The time of last activity from the reference date
  BOOL pouring_; // YES if we are currently pouring
  
  KBKegProcessing *processing_;
  
  KBDataStore *dataStore_;

  NSTimer *loginTimer_;

  NSString *username_;
}

@property (readonly, retain, nonatomic) KBUser *loginUser;
@property (readonly, retain) KBDataStore *dataStore;
@property (readonly, nonatomic) KBKegProcessing *processing;

/*!
 Start the processor.
 */
- (void)start;

/*!
 Login user.
 User will logout automatically after a timeout (if not pouring).
 */
- (void)login:(KBUser *)user;

/*!
 Login user with tag id.
 @param tagId
 @result nil if user unknown
 */
- (KBUser *)loginWithTagId:(NSString *)tagId;

/*!
 Logout.
 Will post logout notification.
 */
- (void)logout;

@end

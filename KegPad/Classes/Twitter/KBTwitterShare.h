//
//  KBTwitterShare.h
//  KegPad
//
//  Created by Gabriel Handford on 5/10/11.
//  Copyright 2011. All rights reserved.
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

#import "MGTwitterEngine.h"

#import "KBKegTemperature.h"
#import "KBKeg.h"


@interface KBTwitterShare : NSObject <MGTwitterEngineDelegate> {
  MGTwitterEngine *twitterEngine_;  
  
  KBKegTemperature *lastTemperature_;
  KBKeg *lastKeg_;
}

- (BOOL)connect;

- (NSString *)kegPadName;

- (void)close;

- (BOOL)sendUpdateWithStatus:(NSString *)status;

@end

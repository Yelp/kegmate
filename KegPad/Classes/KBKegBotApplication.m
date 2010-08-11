//
//  KBKegBotApplication.m
//  KegBot
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

#import "KBKegBotApplication.h"

@implementation KBKegBotApplication

@dynamic delegate;

static NSObject<KBKegBotApplicationDelegate> *KBKegBotApplicationSharedDelegate = NULL;

+ (NSObject<KBKegBotApplicationDelegate> *)sharedDelegate {
  if (KBKegBotApplicationSharedDelegate != NULL) return KBKegBotApplicationSharedDelegate; // For overriding shared delegate (in tests)
  return (NSObject<KBKegBotApplicationDelegate> *)[self sharedApplication].delegate;
}

+ (void)setSharedDelegate:(NSObject<KBKegBotApplicationDelegate> *)sharedDelegate {
  [KBKegBotApplicationSharedDelegate release];
  KBKegBotApplicationSharedDelegate = [sharedDelegate retain];
}

// Shortcuts to application delegate methods

+ (KBKegProcessor *)kegProcessor {
  return [[self sharedDelegate] kegProcessor];
}

+ (KBDataStore *)dataStore {
  return [[self sharedDelegate] kegProcessor].dataStore;
}

@end

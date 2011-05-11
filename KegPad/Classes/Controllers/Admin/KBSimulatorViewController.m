//
//  KBSimulatorViewController.m
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
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

#import "KBSimulatorViewController.h"

#import "KBApplication.h"

@implementation KBSimulatorViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    kegManagerSimulator_ = [[KBKegManagerSimulator alloc] initWithKegProcessor:[KBApplication kegManager]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate temperature and pour" text:@"" target:kegManagerSimulator_ action:@selector(temperatureAndPour) showDisclosure:NO]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate temperatures (multiple)" text:@"" target:kegManagerSimulator_ action:@selector(temperatures) showDisclosure:NO]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate login (Admin)" text:nil target:kegManagerSimulator_ action:@selector(login:) context:@"ADMIN" showDisclosure:NO]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate unknown tag" text:@"" target:kegManagerSimulator_ action:@selector(unknownTag) showDisclosure:NO]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate pours (multiple)" text:@"" target:kegManagerSimulator_ action:@selector(pours) showDisclosure:NO]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate pours (multiple short)" text:@"" target:kegManagerSimulator_ action:@selector(poursShort) showDisclosure:NO]];
    [self addForm:[KBUIForm formWithTitle:@"Simulate pours (short)" text:@"" target:kegManagerSimulator_ action:@selector(pourShort) showDisclosure:NO]];    
    [self addForm:[KBUIForm formWithTitle:@"Simulate pour (long)" text:@"" target:kegManagerSimulator_ action:@selector(pourLong) showDisclosure:NO]];    
  }
  return self;
}

- (void)dealloc {
  [kegManagerSimulator_ release];
  [super dealloc];
}

@end

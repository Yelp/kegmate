//
//  KBUIFormSwitch.h
//  KegPad
//
//  Created by Gabe on 10/10/10.
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

#import "KBUIForm.h"
#import "KBUIFormSwitchCell.h"

@interface KBUIFormSwitch : KBUIForm {
  KBUIFormSwitchCell *cell_;
  
  BOOL on_;
}

@property (assign, nonatomic, getter=isOn) BOOL on;

+ (KBUIFormSwitch *)formWithTitle:(NSString *)title on:(BOOL)on;

- (UISwitch *)switchField;

@end

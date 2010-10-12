//
//  KBUIFormSwitch.m
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

#import "KBUIFormSwitch.h"


@implementation KBUIFormSwitch

@synthesize on=on_;

- (id)init {
  if ((self = [super init])) {
    self.selectEnabled = NO;
    cell_ = [[KBUIFormSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }
  return self;
}

- (void)dealloc {
  [cell_ release];
  [super dealloc];
}

- (UISwitch *)switchField {
  return cell_.switchField;
}

+ (KBUIFormSwitch *)formWithTitle:(NSString *)title on:(BOOL)on {
  KBUIFormSwitch *form = (KBUIFormSwitch *)[self formWithTitle:title text:nil];
  form.on = on;
  return form;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  cell_.selectionStyle = (self.selectEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone);
  cell_.textLabel.text = self.title;
  cell_.switchField.on = self.on;
  cell_.accessoryType = UITableViewCellAccessoryNone;
  return cell_;
}

- (void)performAction {
  // TODO?
}

@end

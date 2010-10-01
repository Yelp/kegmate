//
//  KBUIFormTextField.m
//  KegPad
//
//  Created by Gabe on 9/28/10.
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

#import "KBUIFormTextField.h"

@implementation KBUIFormTextField

@synthesize secureTextEntry=secureTextEntry_, editable=editable_;

- (id)init {
  if ((self = [super init])) {
    self.selectEnabled = NO;
    editable_ = YES;    
    cell_ = [[KBFormFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  }
  return self;
}

- (void)dealloc {
  [cell_ release];
  [super dealloc];
}

- (UITextField *)textField {
  return cell_.textField;
}

+ (KBUIFormTextField *)actionWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable {
  KBUIFormTextField *action = (KBUIFormTextField *)[self actionWithTitle:title text:text];
  action.editable = editable;
  return action;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  cell_.editable = editable_;
  cell_.selectionStyle = (self.selectEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone);
  cell_.textLabel.text = self.title;
  cell_.textField.text = self.text;
  cell_.textField.enabled = editable_;
  cell_.accessoryType = UITableViewCellAccessoryNone;
  cell_.textField.secureTextEntry = secureTextEntry_;
  return cell_;
}

- (void)performAction {
  if (editable_)
    [[self textField] becomeFirstResponder];
}

@end

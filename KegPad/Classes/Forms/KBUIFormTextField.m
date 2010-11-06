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

- (id)initWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable {
  if ((self = [super initWithTitle:title text:text target:nil action:NULL context:nil showDisclosure:NO selectedAction:NULL])) {
    editable_ = YES;    
    cell_ = [[KBUIFormFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    self.selectEnabled = NO;
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

+ (KBUIFormTextField *)formTextFieldWithTitle:(NSString *)title text:(NSString *)text {
  return [self formTextFieldWithTitle:title text:text editable:YES];
}

+ (KBUIFormTextField *)formTextFieldWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable {
  return [[[KBUIFormTextField alloc] initWithTitle:title text:text editable:editable] autorelease];  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  cell_.editable = editable_;
  cell_.selectionStyle = (self.isSelectEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone);
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

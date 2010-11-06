//
//  KBUIFormTextField.h
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

#import "KBUIForm.h"
#import "KBUIFormFieldCell.h"

@interface KBUIFormTextField : KBUIForm {
  BOOL secureTextEntry_;
  BOOL editable_;
  
  KBUIFormFieldCell *cell_;
}

@property (assign, nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@property (assign, nonatomic, getter=isEditable) BOOL editable;

- (id)initWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable;

+ (KBUIFormTextField *)formTextFieldWithTitle:(NSString *)title text:(NSString *)text;

+ (KBUIFormTextField *)formTextFieldWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable;

- (UITextField *)textField;

@end

//
//  KBUIFormField.h
//  KegPad
//
//  Created by Gabe on 9/28/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIForm.h"
#import "KBFormFieldCell.h"

@interface KBUIFormField : KBUIForm {
  BOOL secureTextEntry_;
  BOOL editable_;
  
  KBFormFieldCell *cell_;
}

@property (assign, nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@property (assign, nonatomic, getter=isEditable) BOOL editable;

+ (KBUIFormField *)actionWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable;

- (UITextField *)textField;

@end

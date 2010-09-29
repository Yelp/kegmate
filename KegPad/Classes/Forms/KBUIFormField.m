//
//  KBUIFormField.m
//  KegPad
//
//  Created by Gabe on 9/28/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIFormField.h"

@implementation KBUIFormField

@synthesize secureTextEntry=secureTextEntry_, editable=editable_;

- (id)init {
  if ((self = [super init])) {
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

+ (KBUIFormField *)actionWithTitle:(NSString *)title text:(NSString *)text editable:(BOOL)editable {
  KBUIFormField *action = (KBUIFormField *)[self actionWithTitle:title text:text];
  action.editable = editable;
  return action;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  cell_.editable = editable_;
  cell_.textLabel.text = self.title;
  KBDebug(@"Cell text: %@", self.text);
  cell_.textField.text = self.text;
  cell_.accessoryType = UITableViewCellAccessoryNone;
  cell_.textField.secureTextEntry = secureTextEntry_;
  return cell_;
}

@end

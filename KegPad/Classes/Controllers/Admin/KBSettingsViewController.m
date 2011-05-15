//
//  KBSettingsViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBSettingsViewController.h"

@interface KBSettingsViewController ()
- (NSString *)_password;
@end

@implementation KBSettingsViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Settings";
    nameField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Name" text:[[NSUserDefaults standardUserDefaults] objectForKey:@"KegPadName"]] retain];
    [nameField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:nameField_ section:0];  
    
    passwordField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Password" text:nil] retain];
    passwordField_.textField.delegate = self;
    passwordField_.text = [self _password];
    [passwordField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:passwordField_ section:1];
  }
  return self;
}

- (NSString *)_password {
  NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"AdminPassword"];
  if (!password) password = @"kegmate";  
  return password;
}

- (void)_onTextFieldDidChange:(id)sender {
  // Save on any edits
  [[NSUserDefaults standardUserDefaults] setObject:[nameField_.text gh_strip] forKey:@"KegPadName"];
  [[NSUserDefaults standardUserDefaults] setObject:[passwordField_.text gh_strip] forKey:@"AdminPassword"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

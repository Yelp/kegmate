//
//  KBAdminLoginViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 5/10/11.
//  Copyright 2011. All rights reserved.
//

#import "KBAdminLoginViewController.h"

#import "KBAdminViewController.h"


@implementation KBAdminLoginNavigationController

- (id)init {
  if ((self = [super init])) {
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    KBAdminLoginViewController *adminLoginViewController = [[KBAdminLoginViewController alloc] init];
    [self pushViewController:adminLoginViewController animated:NO];
    [adminLoginViewController release];
  }
  return self;
}   

@end

@implementation KBAdminLoginViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Admin";
    passwordField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Password" text:nil] retain];
    passwordField_.secureTextEntry = YES;
    passwordField_.textField.delegate = self;
    [self addForm:passwordField_];
  }
  return self;
}

- (BOOL)_login {
  NSString *password = passwordField_.textField.text;
  
  NSString *match = [[NSUserDefaults standardUserDefaults] objectForKey:@"AdminPassword"];
  if (!match) match = @"kegmate";
  
  if (![password isEqualToString:match]) return NO;
  [passwordField_.textField resignFirstResponder];
  KBAdminViewController *adminViewController = [[KBAdminViewController alloc] init];
  [self.navigationController pushViewController:adminViewController animated:YES];
  [adminViewController release];
  return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {  
  return [self _login];
}

@end

//
//  KBAdminLoginViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 5/10/11.
//  Copyright 2011. All rights reserved.
//

#import "KBAdminLoginViewController.h"

#import "KBAdminViewController.h"
#import "KBAboutViewController.h"


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

@interface KBAdminLoginViewController ()
- (NSString *)_password;
@end

@implementation KBAdminLoginViewController

- (id)init {
  return [self initWithEditable:NO];
}

- (id)initWithEditable:(BOOL)editable {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Admin";
    passwordField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Password" text:nil] retain];
    passwordField_.secureTextEntry = !editable;
    passwordField_.textField.clearsOnBeginEditing = YES;
    passwordField_.textField.clearButtonMode = UITextFieldViewModeAlways;
    passwordField_.textField.delegate = self;
    [self addForm:passwordField_];
    
    if (editable) {
      passwordField_.text = [self _password];
      [passwordField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    } else {
      self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancel)] autorelease];
      [self addForm:[KBUIForm formWithTitle:@"About" text:nil target:self action:@selector(_about) showDisclosure:YES] section:1];
    }
  }
  return self;
}

- (void)_cancel {
  [self dismissModalViewControllerAnimated:YES];
}

- (NSString *)_password {
  NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"AdminPassword"];
  if (!password) password = @"kegmate";  
  return password;
}

- (void)_about {
  KBAboutViewController *aboutViewController = [[KBAboutViewController alloc] init];
  [self.navigationController pushViewController:aboutViewController animated:YES];
  [aboutViewController release];
}

- (BOOL)_login {
  NSString *password = passwordField_.text;
  if (![password isEqualToString:[self _password]]) return NO;
  [passwordField_.textField resignFirstResponder];
  KBAdminViewController *adminViewController = [[KBAdminViewController alloc] init];
  [self.navigationController pushViewController:adminViewController animated:YES];
  [adminViewController release];
  return YES;
}

- (void)_onTextFieldDidChange:(id)sender {
  // Save on any edits
  [[NSUserDefaults standardUserDefaults] setObject:[passwordField_.text gh_strip] forKey:@"AdminPassword"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {  
  return [self _login];
}

@end

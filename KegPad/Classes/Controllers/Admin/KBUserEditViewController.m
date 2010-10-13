//
//  KBUserEditViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
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

#import "KBUserEditViewController.h"

#import "KBUser.h"
#import "KBApplication.h"
#import "KBNotifications.h"


@interface KBUserEditViewController ()
- (void)_updateNavigationItem;
@end

@implementation KBUserEditViewController

@dynamic delegate;

- (id)init {
  return [self initWithTitle:@"User" buttonTitle:nil adminOptionEnabled:YES logoutEnabled:NO];
}

- (id)initWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle adminOptionEnabled:(BOOL)adminOptionEnabled logoutEnabled:(BOOL)logoutEnabled {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = title;
    if (!buttonTitle) {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_save)] autorelease];
    } else {
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStylePlain target:self action:@selector(_save)] autorelease];
    }
    firstNameField_ = [[KBUIFormTextField formWithTitle:@"First Name" text:nil] retain];
    firstNameField_.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [firstNameField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:firstNameField_];
    lastNameField_ = [[KBUIFormTextField formWithTitle:@"Last Name" text:nil] retain];
    lastNameField_.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [lastNameField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:lastNameField_];
    tagField_ = [[KBUIFormTextField formWithTitle:@"Tag" text:nil] retain];
    [tagField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:tagField_];
    isAdminField_ = [[KBUIFormSwitch formWithTitle:@"Admin" on:NO] retain];
    if (adminOptionEnabled)
      [self addForm:isAdminField_];

    if (logoutEnabled)
      [self addForm:[KBUIForm formWithTitle:@"Log out" text:nil target:self action:@selector(_logout) showDisclosure:NO] section:1];
  }
  return self;
}

- (void)dealloc {
  [firstNameField_ release];
  [lastNameField_ release];
  [tagField_ release];
  [isAdminField_ release];
  [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self _updateNavigationItem];
}

- (void)_logout {
  [[KBApplication kegManager] logout];
  if ([self.delegate respondsToSelector:@selector(userEditViewControllerDidLogout:)])
    [self.delegate userEditViewControllerDidLogout:self];
}

- (void)setUser:(KBUser *)user {
  firstNameField_.text = user.firstName;
  lastNameField_.text = user.lastName;
  tagField_.text = user.tagId;
  isAdminField_.on = user.isAdminValue;
}

- (void)setTagId:(NSString *)tagId editable:(BOOL)editable {
  tagField_.text = tagId;
  tagField_.editable = editable;
  isAdminField_.on = NO;
}

- (BOOL)validate {
  NSString *firstName = firstNameField_.textField.text;
  NSString *lastName = lastNameField_.textField.text;
  NSString *tagId = tagField_.textField.text;
  return (!([NSString gh_isBlank:firstName] || [NSString gh_isBlank:lastName] || [NSString gh_isBlank:tagId]));
}

- (void)_updateNavigationItem {
  self.navigationItem.rightBarButtonItem.enabled = [self validate];
}

- (void)_onTextFieldDidChange:(id)sender {
  [self _updateNavigationItem];
}

- (void)_save {
  if (![self validate]) return;
  NSString *firstName = firstNameField_.textField.text;
  NSString *lastName = lastNameField_.textField.text;
  NSString *tagId = tagField_.textField.text;
  BOOL isAdmin = isAdminField_.switchField.on;
  
  NSError *error = nil;
  KBUser *user = [[KBApplication dataStore] addOrUpdateUserWithTagId:tagId firstName:firstName 
                                                            lastName:lastName isAdmin:isAdmin
                                                               error:&error];
    
  if (!user) {
    [self showError:error];
    return;
  }
  
  [self.delegate userEditViewController:self didAddUser:user];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidEditNotification object:user];
}

@end


@implementation KBUserEditNavigationController

@synthesize userEditViewController=userEditViewController_;

- (id)init {
  return [self initWithTitle:@"Sign Up" buttonTitle:@"Sign Up"];
}

- (id)initWithTitle:(NSString *)title buttonTitle:(NSString *)buttonTitle {
  if ((self = [super init])) {
    userEditViewController_ = [[KBUserEditViewController alloc] initWithTitle:title buttonTitle:buttonTitle adminOptionEnabled:NO logoutEnabled:YES];
    userEditViewController_.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.viewControllers = [NSArray arrayWithObject:userEditViewController_];
  }
  return self;
}

- (void)dealloc {
  [userEditViewController_ release];
  [super dealloc];
}

- (void)cancel {
  [self dismissModalViewControllerAnimated:YES];
}

@end
//
//  KBSignUpViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBSignUpViewController.h"

#import "KBUser.h"
#import "KBApplication.h"
#import "KBNotifications.h"

@implementation KBSignUpViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Sign Up";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(signUp)] autorelease];
    firstNameField_ = [[KBUIFormField actionWithTitle:@"First Name" text:nil] retain];
    [self addAction:firstNameField_];
    lastNameField_ = [[KBUIFormField actionWithTitle:@"Last Name" text:nil] retain];
    [self addAction:lastNameField_];
    tagField_ = [[KBUIFormField actionWithTitle:@"Tag" text:nil editable:NO] retain];
    [self addAction:tagField_];
  }
  return self;
}

- (void)dealloc {
  [firstNameField_ release];
  [lastNameField_ release];
  [tagField_ release];
  [super dealloc];
}

- (NSString *)firstName {
  return firstNameField_.textField.text;
}

- (NSString *)lastName {
  return lastNameField_.textField.text;
}

- (void)setTagId:(NSString *)tagId {
  KBDebug(@"tagId=%@", tagId);
  tagField_.text = tagId;
  [self reload];
}

- (NSString *)tagId {
  return tagField_.textField.text;
}

- (void)cancel {
  [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)signUp {
  NSString *tagId = [self tagId];
  NSString *firstName = [self firstName];
  NSString *lastName = [self lastName];
  KBDebug(@"tagId=%@, firstName=%@, lastName=%@", tagId, firstName, lastName);
  
  // TODO(gabe): Proper validation, show error
  if ([firstName gh_isBlank]) return;
  if ([lastName gh_isBlank]) return;
  if ([tagId gh_isBlank]) return;
  
  NSError *error = nil;
  KBUser *user = [[KBApplication dataStore] addOrUpdateUserWithTagId:tagId firstName:firstName 
    lastName:lastName error:&error];
    
  if (!user) {
    // TODO(gabe): Show error
    return;
  }
  
  [[NSNotificationCenter defaultCenter] postNotificationName:KBUserDidSignUpNotification object:user];
  
  [self.navigationController dismissModalViewControllerAnimated:YES];
}

@end


@implementation KBSignUpNavigationController

- (id)init {
  if ((self = [super init])) {
    signUpViewController_ = [[KBSignUpViewController alloc] init];
    self.modalPresentationStyle = UIModalPresentationFormSheet;
    self.viewControllers = [NSArray arrayWithObject:signUpViewController_];
  }
  return self;
}

- (void)dealloc {
  [signUpViewController_ release];
  [super dealloc];
}

- (void)setTagId:(NSString *)tagId {
  [signUpViewController_ setTagId:tagId];
}

@end
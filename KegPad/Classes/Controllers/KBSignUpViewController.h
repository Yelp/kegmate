//
//  KBSignUpViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBUIFormViewController.h"
#import "KBUIFormField.h"

@interface KBSignUpViewController : KBUIFormViewController { 
  KBUIFormField *firstNameField_;
  KBUIFormField *lastNameField_;  
  KBUIFormField *tagField_;
}

- (NSString *)firstName;
- (NSString *)lastName;
- (NSString *)tagId;

- (void)setTagId:(NSString *)tagId;

@end


@interface KBSignUpNavigationController : UINavigationController {
  KBSignUpViewController *signUpViewController_;
}

- (void)setTagId:(NSString *)tagId;

@end
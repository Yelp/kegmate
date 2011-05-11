//
//  KBTwitterAdminViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 5/10/11.
//  Copyright 2011. All rights reserved.
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


#import "KBTwitterAdminViewController.h"

#import "KBApplication.h"
#import "KBNotifications.h"


@implementation KBTwitterAdminViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Twitter";

    consumerKeyField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Consumer Key" text:[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterConsumerKey"]] retain];
    consumerKeyField_.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    consumerKeyField_.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [consumerKeyField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:consumerKeyField_];  
    
    consumerSecretField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Consumer Secret" text:[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterConsumerSecret"]] retain];
    consumerSecretField_.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    consumerSecretField_.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [consumerSecretField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:consumerSecretField_];  
    
    accessTokenField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Access Token" text:[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterAccessToken"]] retain];
    accessTokenField_.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    accessTokenField_.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [accessTokenField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:accessTokenField_];  
    
    accessTokenSecretField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Access Token Secret" text:[[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterAccessTokenSecret"]] retain];
    accessTokenSecretField_.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    accessTokenSecretField_.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    [accessTokenSecretField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addForm:accessTokenSecretField_];    
  }
  return self;
}

- (void)dealloc {
  [consumerKeyField_ release];
  [consumerSecretField_ release];
  [accessTokenField_ release];
  [accessTokenSecretField_ release];
  [super dealloc];
}

- (void)_onTextFieldDidChange:(id)sender {
  [[NSUserDefaults standardUserDefaults] setObject:consumerKeyField_.textField.text forKey:@"TwitterConsumerKey"];
  [[NSUserDefaults standardUserDefaults] setObject:consumerSecretField_.textField.text forKey:@"TwitterConsumerSecret"];  
  [[NSUserDefaults standardUserDefaults] setObject:accessTokenField_.textField.text forKey:@"TwitterAccessToken"];
  [[NSUserDefaults standardUserDefaults] setObject:accessTokenSecretField_.textField.text forKey:@"TwitterAccessTokenSecret"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:KBTwitterCredentialsDidChange object:nil];
}

@end

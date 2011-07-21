//
//  KBSettingsViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 5/14/11.
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

#import "KBSettingsViewController.h"


@interface KBSettingsViewController ()
- (NSString *)_password;
- (void)_onChanged;
@end

@implementation KBSettingsViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Settings";
    nameField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Name" text:[[NSUserDefaults standardUserDefaults] objectForKey:@"KegPadName"]] retain];
    [self addForm:nameField_ section:0];  
    
    passwordField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Password" text:nil] retain];
    passwordField_.textField.delegate = self;
    passwordField_.text = [self _password];
    [self addForm:passwordField_ section:1];
    
    tweetAnonymousField_ = [[KBUIFormSwitch alloc] initWithTitle:@"Tweet anonymous pours" on:[[NSUserDefaults standardUserDefaults] gh_boolForKey:@"TweetAnonymous" withDefault:NO]];
    [self addForm:tweetAnonymousField_ section:2];
    
    double maxPourAmountInLiters = [[NSUserDefaults standardUserDefaults] gh_doubleForKey:@"MaxPourAmountInLiters" withDefault:2.5];
    maxPourAmountField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Max pour allowed (liters)" text:[NSString stringWithFormat:@"%0.2f", maxPourAmountInLiters]] retain];
    [self addForm:maxPourAmountField_ section:3];  

  }
  return self;
}

- (void)viewWillDisappear:(BOOL)viewWillDisappear {
  [super viewWillDisappear:viewWillDisappear];
  [self _onChanged];
}

- (NSString *)_password {
  NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"AdminPassword"];
  if (!password) password = @"kegmate";  
  return password;
}

- (void)_onChanged {
  [[NSUserDefaults standardUserDefaults] setObject:[nameField_.text gh_strip] forKey:@"KegPadName"];
  [[NSUserDefaults standardUserDefaults] setObject:[passwordField_.text gh_strip] forKey:@"AdminPassword"];
  [[NSUserDefaults standardUserDefaults] gh_setBool:tweetAnonymousField_.isOn forKey:@"TweetAnonymous"];
  
  double maxPourAmount = [[maxPourAmountField_.text gh_strip] doubleValue];
  if (maxPourAmount <= 0) maxPourAmount = 2.5;
  
  [[NSUserDefaults standardUserDefaults] setDouble:maxPourAmount forKey:@"MaxPourAmountInLiters"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

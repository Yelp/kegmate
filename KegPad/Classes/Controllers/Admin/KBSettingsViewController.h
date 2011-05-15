//
//  KBSettingsViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 5/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBUIFormViewController.h"

#import "KBUIFormTextField.h"


@interface KBSettingsViewController : KBUIFormViewController <UITextFieldDelegate> {
  KBUIFormTextField *nameField_;
  KBUIFormTextField *passwordField_;
}

@end
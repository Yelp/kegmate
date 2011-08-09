//
//  KegTimeHostEditViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBUIFormViewController.h"
#import "KBUIFormTextField.h"
#import "KBKegTimeHost.h"


@class KegTimeHostEditViewController;

@protocol KegTimeHostEditViewControllerDelegate <NSObject>
- (void)kegTimeHostEditViewController:(KegTimeHostEditViewController *)kegTimeHostEditViewController didAddHost:(KBKegTimeHost *)host;
@end


@interface KegTimeHostEditViewController : KBUIFormViewController {
  KBUIFormTextField *_nameField;
  KBUIFormTextField *_addressField;
  KBUIFormTextField *_portField;
  
  id<KegTimeHostEditViewControllerDelegate> _delegate;
}

@property (assign, nonatomic) id<KegTimeHostEditViewControllerDelegate> delegate;

@end

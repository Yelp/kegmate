//
//  KBKegEditViewController.h
//  KegPad
//
//  Created by Gabe on 9/30/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIFormViewController.h"
#import "KBUIFormTextField.h"
#import "KBKeg.h"

@class KBKegEditViewController;

@protocol KBKegEditViewControllerDelegate <NSObject>
- (void)kegEditViewController:(KBKegEditViewController *)kegEditViewController didAddKeg:(KBKeg *)keg;
@end

@interface KBKegEditViewController : KBUIFormViewController { 
  KBUIFormTextField *beerField_;
}

@property (assign, nonatomic) id<KBKegEditViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)title;

@end

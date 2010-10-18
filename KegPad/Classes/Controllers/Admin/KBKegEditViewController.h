//
//  KBKegEditViewController.h
//  KegPad
//
//  Created by Gabe on 9/30/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIFormViewController.h"
#import "KBUIFormListSelect.h"
#import "KBUIFormTextField.h"
#import "KBKeg.h"
#import "KBBeersViewController.h"

@class KBKegEditViewController;

@protocol KBKegEditViewControllerDelegate <NSObject>
- (void)kegEditViewController:(KBKegEditViewController *)kegEditViewController didSaveKeg:(KBKeg *)keg;
@end

@interface KBKegEditViewController : KBUIFormViewController <KBBeersViewControllerDelegate> { 
  KBUIFormListSelect *beerSelect_;
  KBUIFormTextField *volumeAdjustedField_;
  KBUIFormTextField *volumePouredField_;
  KBUIFormTextField *volumeTotalField_;
  
  KBKeg *keg_;
}

@property (assign, nonatomic) id<KBKegEditViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)title useEnabled:(BOOL)useEnabled;

- (void)setKeg:(KBKeg *)keg;

@end

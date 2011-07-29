//
//  KBRKKegEditViewController.h
//  KegPad
//
//  Created by John Boiles on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBUIFormViewController.h"
#import "KBUIFormListSelect.h"
#import "KBUIFormTextField.h"
#import "KBRKKeg.h"
#import "KBRKBeerTypesViewController.h"

@class KBRKKegEditViewController;

@protocol KBRKKegEditViewControllerDelegate <NSObject>
- (void)kegEditViewController:(KBRKKegEditViewController *)kegEditViewController didSaveKeg:(KBRKKeg *)keg;
@end

@interface KBRKKegEditViewController : KBUIFormViewController <KBRKBeerTypesViewControllerDelegate> {
  KBUIFormListSelect *beerTypeSelect_;
  KBUIFormTextField *volumeAdjustedField_;
  KBUIFormTextField *volumePouredField_;
  KBUIFormTextField *volumeTotalField_;

  KBRKKeg *keg_;
}

@property (assign, nonatomic) id<KBRKKegEditViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)title useEnabled:(BOOL)useEnabled;

- (void)setKeg:(KBRKKeg *)keg;

@end

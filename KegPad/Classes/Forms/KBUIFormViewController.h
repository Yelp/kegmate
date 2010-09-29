//
//  KBUIFormViewController.h
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIForm.h"

@class KBUIFormViewController;

@protocol KBUIFormViewControllerDelegate <NSObject>
@optional
- (void)actionViewController:(KBUIFormViewController *)actionViewController willSelectAction:(KBUIForm *)action;
- (void)actionViewController:(KBUIFormViewController *)actionViewController didSelectAction:(KBUIForm *)action;
@end

@interface KBUIFormViewController : UITableViewController {

  NSMutableDictionary *sections_;
  
  id<KBUIFormViewControllerDelegate> delegate_;
}

@property (assign, nonatomic) id<KBUIFormViewControllerDelegate> delegate; // Weak

- (void)addAction:(KBUIForm *)action;

- (void)addAction:(KBUIForm *)action section:(NSInteger)section;

- (KBUIForm *)actionForIndexPath:(NSIndexPath *)indexPath;

- (void)reload;

@end

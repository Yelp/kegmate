//
//  KBActionViewController.h
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIAction.h"

@class KBActionViewController;

@protocol KBActionViewControllerDelegate <NSObject>
@optional
- (void)actionViewController:(KBActionViewController *)actionViewController willSelectAction:(KBUIAction *)action;
- (void)actionViewController:(KBActionViewController *)actionViewController didSelectAction:(KBUIAction *)action;
@end

@interface KBActionViewController : UITableViewController {
  NSMutableArray *options_;
  
  id<KBActionViewControllerDelegate> delegate_;
}

@property (assign, nonatomic) id<KBActionViewControllerDelegate> delegate; // Weak

- (void)addAction:(KBUIAction *)action;

@end

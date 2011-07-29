//
//  KBUIFormViewController.h
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
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

#import "KBUIForm.h"

@class KBUIFormViewController;

@protocol KBUIFormViewControllerDelegate <NSObject>
@optional
- (void)formViewController:(KBUIFormViewController *)formViewController willSelectForm:(KBUIForm *)form;
- (void)formViewController:(KBUIFormViewController *)formViewController didSelectForm:(KBUIForm *)form;
@end

@interface KBUIFormViewController : UITableViewController {

  NSMutableDictionary *sections_;
  NSInteger sectionCount_;
  
  id<KBUIFormViewControllerDelegate> delegate_;
}

@property (assign, nonatomic) id<KBUIFormViewControllerDelegate> delegate; // Weak

- (void)addForm:(KBUIForm *)form;

- (void)addForm:(KBUIForm *)form section:(NSInteger)section;

- (void)removeFromSection:(NSInteger)section;

- (NSArray *)formsForSection:(NSInteger)section;

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)showError:(NSError *)error;

- (KBUIForm *)formForIndexPath:(NSIndexPath *)indexPath;

- (void)reload;

@end

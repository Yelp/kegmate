//
//  KBUIForm.h
//  KegPad
//
//  Created by Gabriel Handford on 8/9/10.
//  Copyright 2010 Yelp. All rights reserved.
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

/*!
 Handles generic actions in UITableView contexts.
 */
@interface KBUIForm : NSObject {
  NSString *title_;
  NSString *text_;
  BOOL showDisclosure_;
  
  id target_; // weak
  SEL action_;
  SEL selectedAction_; // Selector to call (returns BOOL) to set selected state
  
  BOOL selectEnabled_;
  
  id context_;
}

@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *text;
@property (readonly, nonatomic) BOOL showDisclosure;
@property (readonly, nonatomic, getter=isSelected) BOOL selected;
@property (assign, nonatomic, getter=isSelectEnabled) BOOL selectEnabled;

- (id)initWithTitle:(NSString *)title text:(NSString *)text target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure selectedAction:(SEL)selectedAction;
+ (KBUIForm *)actionWithTitle:(NSString *)title text:(NSString *)text;
+ (KBUIForm *)actionWithTitle:(NSString *)title text:(NSString *)text target:(id)target action:(SEL)action showDisclosure:(BOOL)showDisclosure;
+ (KBUIForm *)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure;
+ (KBUIForm *)actionWithTitle:(NSString *)title target:(id)target action:(SEL)action selectedAction:(SEL)selectedAction;

- (void)performAction;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

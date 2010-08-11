//
//  KBUIAction.h
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
@interface KBUIAction : NSObject {
  NSString *_name;
  NSString *_info;
  BOOL _showDisclosure;
  
  id _target; // weak
  SEL _action;
  SEL _selectedAction; // Selector to call (returns BOOL) to set selected state
  
  id _context;
}

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *info;
@property (readonly, nonatomic) BOOL showDisclosure;
@property (readonly, nonatomic, getter=isSelected) BOOL selected;

- (id)initWithName:(NSString *)name info:(NSString *)info target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure selectedAction:(SEL)selectedAction;
+ (KBUIAction *)actionWithName:(NSString *)name info:(NSString *)info target:(id)target action:(SEL)action showDisclosure:(BOOL)showDisclosure;
+ (KBUIAction *)actionWithName:(NSString *)name target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure;
+ (KBUIAction *)actionWithName:(NSString *)name target:(id)target action:(SEL)action selectedAction:(SEL)selectedAction;

- (void)performAction;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

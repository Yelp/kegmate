//
//  KBUIForm.m
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

#import "KBUIForm.h"

@implementation KBUIForm

@synthesize title=title_, text=text_, showDisclosure=showDisclosure_, selectEnabled=selectEnabled_;

- (id)initWithTitle:(NSString *)title text:(NSString *)text target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure selectedAction:(SEL)selectedAction {
  if ((self = [self init])) {
    title_ = [title retain];
    text_ = [text retain];
    target_ = [target retain]; // Circular retain but necessary for targets that get popped from nav stack
    action_ = action;
    context_ = [context retain];
    showDisclosure_ = showDisclosure;
    selectedAction_ = selectedAction;
    selectEnabled_ = YES;
  }
  return self;
}

- (void)dealloc {
  [title_ release];
  [text_ release];
  [target_ release];
  [context_ release];
  [super dealloc];
}

+ (KBUIForm *)formWithTitle:(NSString *)title text:(NSString *)text {
  return [[[self alloc] initWithTitle:title text:text target:nil action:NULL context:nil showDisclosure:NO selectedAction:NULL] autorelease];
}

+ (KBUIForm *)formWithTitle:(NSString *)title text:(NSString *)text target:(id)target action:(SEL)action showDisclosure:(BOOL)showDisclosure {
  return [[[self alloc] initWithTitle:title text:text target:target action:action context:nil showDisclosure:showDisclosure selectedAction:NULL] autorelease];
}

+ (KBUIForm *)formWithTitle:(NSString *)title text:(NSString *)text target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure {
  return [[[self alloc] initWithTitle:title text:text target:target action:action context:context showDisclosure:showDisclosure selectedAction:NULL] autorelease];
}

+ (KBUIForm *)formWithTitle:(NSString *)title target:(id)target action:(SEL)action selectedAction:(SEL)selectedAction {
  return [[[self alloc] initWithTitle:title text:nil target:target action:action context:nil showDisclosure:NO selectedAction:selectedAction] autorelease];
}

- (void)performAction {
  if (target_ && action_ != NULL)
    [target_ performSelector:action_ withObject:context_];  
}

- (BOOL)isSelected {
  if (selectedAction_ == NULL) return NO;
  return (BOOL)(intptr_t)[target_ performSelector:selectedAction_];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"KBUIForm";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  
  cell.textLabel.text = self.title;
  cell.detailTextLabel.text = self.text;
  cell.selectionStyle = (self.isSelectEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone);
  
  if (self.showDisclosure) {
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  } else if (self.isSelected) {
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  } else {
    cell.accessoryType = UITableViewCellAccessoryNone;
  }  
  return cell;
}

@end

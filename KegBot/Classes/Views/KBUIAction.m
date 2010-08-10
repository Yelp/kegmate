//
//  KBUIAction.m
//  KegBot
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

#import "KBUIAction.h"

@implementation KBUIAction

@synthesize name=_name, info=_info, showDisclosure=_showDisclosure;

- (id)initWithName:(NSString *)name info:(NSString *)info target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure selectedAction:(SEL)selectedAction {
  if ((self = [super init])) {
    _name = [name retain];
    _info = [info retain];
    _target = [target retain]; // Circular retain but necessary for targets that get popped from nav stack
    _action = action;
    _context = [context retain];
    _showDisclosure = showDisclosure;
    _selectedAction = selectedAction;
  }
  return self;
}

- (void)dealloc {
  [_name release];
  [_info release];
  [_target release];
  [_context release];
  [super dealloc];
}

+ (KBUIAction *)actionWithName:(NSString *)name info:(NSString *)info target:(id)target action:(SEL)action showDisclosure:(BOOL)showDisclosure {
  return [[[KBUIAction alloc] initWithName:name info:info target:target action:action context:nil showDisclosure:showDisclosure selectedAction:NULL] autorelease];
}

+ (KBUIAction *)actionWithName:(NSString *)name target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure {
  return [[[KBUIAction alloc] initWithName:name info:nil target:target action:action context:context showDisclosure:showDisclosure selectedAction:NULL] autorelease];
}

+ (KBUIAction *)actionWithName:(NSString *)name target:(id)target action:(SEL)action selectedAction:(SEL)selectedAction {
  return [[[KBUIAction alloc] initWithName:name info:nil target:target action:action context:nil showDisclosure:NO selectedAction:selectedAction] autorelease];
}

- (void)performAction {
  if (_target && _action != NULL)
    [_target performSelector:_action withObject:_context];  
}

- (BOOL)isSelected {
  if (_selectedAction == NULL) return NO;
  return (BOOL)(intptr_t)[_target performSelector:_selectedAction];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  static NSString *CellIdentifier = @"KBUIAction";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell)
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  
  cell.textLabel.text = _name;
  cell.detailTextLabel.text = _info;
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

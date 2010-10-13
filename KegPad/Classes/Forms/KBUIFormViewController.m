//
//  KBUIFormViewController.m
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

#import "KBUIFormViewController.h"


@implementation KBUIFormViewController

@synthesize delegate=delegate_;

- (id)initWithStyle:(UITableViewStyle)style {
  if ((self = [super initWithStyle:style])) {
    sections_ = [[NSMutableDictionary alloc] initWithCapacity:10]; 
  }
  return self;
}

- (void)dealloc {
  [sections_ release];
  [super dealloc];
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message
                                                 delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [alert show];
  [alert autorelease];
}  


- (void)showError:(NSError *)error {
  [self showAlertWithTitle:@"Error" message:[error localizedDescription]];
}  

- (void)addForm:(KBUIForm *)form {
  [self addForm:form section:0];
}

- (void)addForm:(KBUIForm *)form section:(NSInteger)section {
  NSNumber *key = [NSNumber numberWithInteger:section];
  NSMutableArray *forms = [sections_ objectForKey:key];
  if (!forms) {
    forms = [NSMutableArray arrayWithCapacity:10];
    [sections_ setObject:forms forKey:key];
  }
  [forms addObject:form];
}

- (KBUIForm *)formForIndexPath:(NSIndexPath *)indexPath {
  NSNumber *key = [NSNumber numberWithInteger:indexPath.section];
  NSMutableArray *forms = [sections_ objectForKey:key];
  return [forms objectAtIndex:indexPath.row];
}

- (void)reload {
  [self.tableView reloadData];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [sections_ count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  NSNumber *key = [NSNumber numberWithInteger:section];
  NSMutableArray *forms = [sections_ objectForKey:key];
  return [forms count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  KBUIForm *form = [self formForIndexPath:indexPath];
  return [form tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBUIForm *form = [self formForIndexPath:indexPath];
  if ([delegate_ respondsToSelector:@selector(formViewController:willSelectForm:)])
    [delegate_ formViewController:self willSelectForm:form];
  [form performAction];
  if ([delegate_ respondsToSelector:@selector(formViewController:didSelectForm:)])
    [delegate_ formViewController:self didSelectForm:form];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

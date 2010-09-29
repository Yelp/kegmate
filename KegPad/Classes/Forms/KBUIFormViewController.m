//
//  KBUIFormViewController.m
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
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

- (void)addAction:(KBUIForm *)action {
  [self addAction:action section:0];
}

- (void)addAction:(KBUIForm *)action section:(NSInteger)section {
  NSNumber *key = [NSNumber numberWithInteger:section];
  NSMutableArray *actions = [sections_ objectForKey:key];
  if (!actions) {
    actions = [NSMutableArray arrayWithCapacity:10];
    [sections_ setObject:actions forKey:key];
  }
  [actions addObject:action];
}

- (KBUIForm *)actionForIndexPath:(NSIndexPath *)indexPath {
  NSNumber *key = [NSNumber numberWithInteger:indexPath.section];
  NSMutableArray *actions = [sections_ objectForKey:key];
  return [actions objectAtIndex:indexPath.row];
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
  NSMutableArray *actions = [sections_ objectForKey:key];
  return [actions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  KBUIForm *action = [self actionForIndexPath:indexPath];
  return [action tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBUIForm *action = [self actionForIndexPath:indexPath];
  if ([delegate_ respondsToSelector:@selector(actionViewController:willSelectAction:)])
    [delegate_ actionViewController:self willSelectAction:action];
  [action performAction];
  if ([delegate_ respondsToSelector:@selector(actionViewController:didSelectAction:)])
    [delegate_ actionViewController:self didSelectAction:action];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

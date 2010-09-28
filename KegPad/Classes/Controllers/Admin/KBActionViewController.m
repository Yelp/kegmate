//
//  KBActionViewController.m
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBActionViewController.h"


@implementation KBActionViewController

@synthesize delegate=delegate_;

- (id)init {
  if ((self = [super init])) {
    options_ = [[NSMutableArray alloc] initWithCapacity:10];
  }
  return self;
}

- (void)addAction:(KBUIAction *)action {
  [options_ addObject:action];
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
  return [options_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {  
  KBUIAction *action = [options_ objectAtIndex:indexPath.row];
  return [action tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
  KBUIAction *action = [options_ objectAtIndex:indexPath.row];
  if ([delegate_ respondsToSelector:@selector(actionViewController:willSelectAction:)])
    [delegate_ actionViewController:self willSelectAction:action];
  [action performAction];
  if ([delegate_ respondsToSelector:@selector(actionViewController:didSelectAction:)])
    [delegate_ actionViewController:self didSelectAction:action];
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end

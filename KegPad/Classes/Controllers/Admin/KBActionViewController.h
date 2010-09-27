//
//  KBActionViewController.h
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIAction.h"

@interface KBActionViewController : UITableViewController {
  NSMutableArray *options_;
}

- (void)addAction:(KBUIAction *)action;

@end

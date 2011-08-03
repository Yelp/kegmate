//
//  KegTimeHostEditViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KegTimeHostEditViewController.h"


@implementation KegTimeHostEditViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Add Host";
    
    _addressField = [[KBUIFormTextField formTextFieldWithTitle:@"IP" text:@""] retain];
    [self addForm:_addressField];
    _portField = [[KBUIFormTextField formTextFieldWithTitle:@"Port" text:@""] retain];
    [self addForm:_portField];

  }
  return self;
}

@end

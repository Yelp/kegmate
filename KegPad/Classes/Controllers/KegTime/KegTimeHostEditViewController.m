//
//  KegTimeHostEditViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KegTimeHostEditViewController.h"

#import "KBApplication.h"

@implementation KegTimeHostEditViewController

@synthesize delegate=_delegate;

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = @"Add Host";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_save)] autorelease];
    _nameField = [[KBUIFormTextField formTextFieldWithTitle:@"Name" text:@""] retain];
    [self addForm:_nameField];
    _addressField = [[KBUIFormTextField formTextFieldWithTitle:@"IP" text:@""] retain];
    [self addForm:_addressField];
    _portField = [[KBUIFormTextField formTextFieldWithTitle:@"Port" text:@""] retain];
    [self addForm:_portField];

  }
  return self;
}

- (void)dealloc {
  [_nameField release];
  [_addressField release];
  [_portField release];
  [super dealloc];
}

- (BOOL)validate {
  NSString *address = _addressField.textField.text;
  NSString *port = _portField.textField.text;
  return (!([NSString gh_isBlank:address] || [NSString gh_isBlank:port]));
}

- (void)_save {
  if (![self validate]) return;
  NSString *name = _nameField.textField.text;
  NSString *address = _addressField.textField.text;
  NSInteger port = [_portField.textField.text integerValue];

  KBKegTimeHost *host = [[KBApplication dataStore] kegTimeHostWithName:name ipAddress:address port:port];
  [_delegate kegTimeHostEditViewController:self didAddHost:host];
}

@end

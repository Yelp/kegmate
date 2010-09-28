//
//  KBSignUpViewController.m
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBSignUpViewController.h"


@implementation KBSignUpViewController

@synthesize delegate=delegate_;

- (id)init {
  if ((self = [super initWithNibName:nil bundle:nil])) { 
    self.title = @"Sign Up";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)] autorelease];
  }
  return self;
}

- (void)cancel {
  [delegate_ signUpViewControllerDidCancel:self];
}

@end
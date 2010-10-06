//
//  KBKegEditViewController.m
//  KegPad
//
//  Created by Gabe on 9/30/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBKegEditViewController.h"

#import "KBUser.h"
#import "KBApplication.h"
#import "KBNotifications.h"

@implementation KBKegEditViewController

@dynamic delegate;

- (id)init {
  return [self initWithTitle:@"Beer"];
}

- (id)initWithTitle:(NSString *)title {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = title;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_add)] autorelease];

    // TODO(gabe): Make beer selector
    beerField_ = [[KBUIFormTextField actionWithTitle:@"Beer (name)" text:nil] retain];
    [self addForm:beerField_];

  }
  return self;
}

- (void)dealloc {
  [beerField_ release];
  [super dealloc];
}

- (BOOL)validate {
  NSString *beerName = beerField_.textField.text;
  return (![NSString gh_isBlank:beerName]);
}

- (void)_add {
  if (![self validate]) return;
  NSString *identifier = [NSString gh_uuid];
  NSString *beerName = beerField_.textField.text;
  KBBeer *beer = [[KBApplication dataStore] beerWithId:beerName error:nil];
  float volumeAdjusted = 0;
  float volumeTotal = 58.67; // Volume in liters of full keg
  
  // TODO(gabe): Validate input
  if (!beer) {    
    return;
  } 
  
  NSError *error = nil;
  KBKeg *keg = [[KBApplication dataStore] addOrUpdateKegWithId:identifier beer:beer volumeAdjusted:volumeAdjusted volumeTotal:volumeTotal error:&error];
    
  if (!keg) {
    [self showError:error];
    return;
  }
  
  [self.delegate kegEditViewController:self didAddKeg:keg];
  // TODO(gabe): Notification
  //[[NSNotificationCenter defaultCenter] postNotificationName: object:beer];
}


@end

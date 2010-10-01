//
//  KBBeerEditViewController.m
//  KegPad
//
//  Created by Gabe on 9/30/10.
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

#import "KBBeerEditViewController.h"

#import "KBUser.h"
#import "KBApplication.h"
#import "KBNotifications.h"

@implementation KBBeerEditViewController

@dynamic delegate;

- (id)init {
  return [self initWithTitle:@"Beer"];
}

- (id)initWithTitle:(NSString *)title {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) { 
    self.title = title;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_add)] autorelease];

    nameField_ = [[KBUIFormTextField actionWithTitle:@"Name" text:nil] retain];
    [self addForm:nameField_];
    infoField_ = [[KBUIFormTextField actionWithTitle:@"Info" text:nil] retain];
    [self addForm:infoField_];
    typeField_ = [[KBUIFormTextField actionWithTitle:@"Type" text:nil] retain];
    [self addForm:typeField_];
    abvField_ = [[KBUIFormTextField actionWithTitle:@"ABV" text:nil] retain];
    [self addForm:abvField_];
    countryField_ = [[KBUIFormTextField actionWithTitle:@"Country" text:nil] retain];
    [self addForm:countryField_];
    imageNameField_ = [[KBUIFormTextField actionWithTitle:@"Image" text:nil] retain];
    [self addForm:imageNameField_];
  }
  return self;
}

- (void)dealloc {
  [nameField_ release];
  [typeField_ release];
  [infoField_ release];
  [abvField_ release];
  [countryField_ release];
  [imageNameField_ release];
  [super dealloc];
}

- (void)_add {
  NSString *name = nameField_.textField.text;
  NSString *info = infoField_.textField.text;
  NSString *type = typeField_.textField.text;
  NSString *country = countryField_.textField.text;
  NSString *imageName = imageNameField_.textField.text;
  float abv = [abvField_.textField.text floatValue];
  
  // TODO(gabe): Validate input
  
  NSError *error = nil;
  KBBeer *beer = [[KBApplication dataStore] addOrUpdateBeerWithId:name name:name info:info type:type country:country imageName:imageName abv:abv error:&error];
    
  if (!beer) {
    // TODO(gabe): Show error
    return;
  }
  
  [self.delegate beerEditViewController:self didAddBeer:beer];
  // TODO(gabe): Notification
  //[[NSNotificationCenter defaultCenter] postNotificationName: object:beer];
}

@end


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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(_save)] autorelease];

    nameField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Name" text:nil] retain];
    [nameField_.textField addTarget:self action:@selector(_onTextFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    nameField_.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self addForm:nameField_];
    infoField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Info" text:nil] retain];
    infoField_.textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    [self addForm:infoField_];
    typeField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Type" text:nil] retain];
    typeField_.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    [self addForm:typeField_];
    abvField_ = [[KBUIFormTextField formTextFieldWithTitle:@"ABV" text:nil] retain];
    abvField_.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    [self addForm:abvField_];
    countryField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Country" text:nil] retain];
    [self addForm:countryField_];

    imageNameField_ = [[KBUIFormTextField formTextFieldWithTitle:@"Image" text:nil] retain];
    [self addForm:imageNameField_ section:1];
    [self addForm:[KBUIForm formWithTitle:@"Choose image from photo library" text:@"" target:self action:@selector(_selectFromPhotoLibrary) showDisclosure:NO] section:1];

    [self addForm:[KBUIForm formWithTitle:@"Google Image Search in Safari (Exits KegPad)" text:@"" target:self action:@selector(_googleImageSearch) showDisclosure:YES] section:2];
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
  [_beerEditId release];
  _imagePickerPopoverController.delegate = nil;
  [_imagePickerPopoverController release];
  [super dealloc];
}

- (void)setBeer:(KBBeer *)beer {
  [_beerEditId autorelease];
  _beerEditId = [beer.id retain];
  nameField_.text = beer.name;
  infoField_.text = beer.info;
  typeField_.text = beer.type;
  abvField_.text = [NSString stringWithFormat:@"%0.2f", beer.abvValue];
  countryField_.text = beer.country;
  imageNameField_.text = beer.imageName;
}

- (BOOL)validate {
  NSString *name = nameField_.textField.text;
  if ([NSString gh_isBlank:name]) {
    [self showAlertWithTitle:@"Error" message:@"Please specify a name"];
    return NO;
  }
  
  NSString *info = infoField_.textField.text;
  if ([NSString gh_isBlank:info]) {
    [self showAlertWithTitle:@"Error" message:@"Please specify info"];
    return NO;
  }
  
  NSString *abv = abvField_.textField.text;
  if ([NSString gh_isBlank:abv]) {
    [self showAlertWithTitle:@"Error" message:@"Please specify an ABV"];
    return NO;
  }
  
  return YES;
}

- (void)_onTextFieldDidChange:(id)sender { }

- (void)_save {
  if (![self validate]) return;
  
  NSString *name = nameField_.textField.text;
  NSString *info = infoField_.textField.text;
  NSString *type = typeField_.textField.text;
  NSString *country = countryField_.textField.text;
  NSString *imageName = imageNameField_.textField.text;
  float abv = [abvField_.textField.text floatValue];
  
  NSString *identifier = _beerEditId;
  if (!identifier) identifier = name;

  NSError *error = nil;
  KBBeer *beer = [[KBApplication dataStore] addOrUpdateBeerWithId:identifier name:name info:info type:type country:country imageName:imageName abv:abv error:&error];
    
  if (!beer) {
    [self showError:error];
    return;
  }
  
  [self.delegate beerEditViewController:self didSaveBeer:beer];
  [[NSNotificationCenter defaultCenter] postNotificationName:KBBeerDidEditNotification object:beer];
}

- (void)_selectFromPhotoLibrary {
  _imagePickerPopoverController.delegate = nil;
  [_imagePickerPopoverController release];
  _imagePickerPopoverController = nil;
  
  UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
  imagePickerController.allowsEditing = YES;
  imagePickerController.delegate = self;
  imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  _imagePickerPopoverController = [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
  _imagePickerPopoverController.delegate = self;
  [_imagePickerPopoverController presentPopoverFromRect:self.view.frame
                                                 inView:imageNameField_.textField
                               permittedArrowDirections:UIPopoverArrowDirectionAny
                                               animated:YES];
  [imagePickerController release];
}

- (void)_googleImageSearch {
  NSString *urlAddress = [NSString stringWithFormat:@"http://www.google.com/images?q=%@",
                          [nameField_.textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  NSURL *url = [NSURL URLWithString:urlAddress];
  [[UIApplication sharedApplication] openURL:url];
}

- (NSString *)_sanitizeFileNameString:(NSString *)fileName {
  NSCharacterSet* illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>#"];
  return [[fileName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
}

#pragma mark Delegates (UIImagePickerController)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  KBDebug(@"%@", info);
  NSString *fileName = [NSString stringWithFormat:@"%@.png", nameField_.textField.text];
  // Sanitize the filename string
  fileName = [self _sanitizeFileNameString:fileName];
  NSString *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", fileName]];
  UIImage *beerImage = [info objectForKey:UIImagePickerControllerEditedImage];
  // Write image to PNG
  [UIImagePNGRepresentation(beerImage) writeToFile:imagePath atomically:YES];
  imageNameField_.textField.text = fileName;
  [_imagePickerPopoverController dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {}

#pragma mark Delegates (UINavigationController)

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {}

#pragma mark Delegates (UIPopoverController)

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [_imagePickerPopoverController release];
  _imagePickerPopoverController = nil;
}

@end


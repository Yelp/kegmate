//
//  KBBeerEditViewController.h
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


#import "KBUIFormViewController.h"
#import "KBUIFormTextField.h"
#import "KBBeer.h"

@class KBBeerEditViewController;

@protocol KBBeerEditViewControllerDelegate <NSObject>
- (void)beerEditViewController:(KBBeerEditViewController *)beerEditViewController didSaveBeer:(KBBeer *)beer;
@end

@interface KBBeerEditViewController : KBUIFormViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate> { 
  KBUIFormTextField *nameField_;
  KBUIFormTextField *typeField_;  
  KBUIFormTextField *infoField_;
  KBUIFormTextField *abvField_;
  KBUIFormTextField *countryField_;
  KBUIFormTextField *imageNameField_;
  
  NSString *_beerEditId;
  UIPopoverController *_imagePickerPopoverController;
}

@property (assign, nonatomic) id<KBBeerEditViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)title;

- (void)setBeer:(KBBeer *)beer;

@end

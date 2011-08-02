//
//  KBRKBeerTypeEditViewController.h
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
#import "KBUIFormListSelect.h"
#import "KBRKBeerType.h"
#import "KBRKBrewersViewController.h"
#import "KBRKBeerStylesViewController.h"

@class KBRKBeerTypeEditViewController;

@protocol KBRKBeerTypeEditViewControllerDelegate <NSObject>
- (void)beerEditViewController:(KBRKBeerTypeEditViewController *)beerEditViewController didSaveBeerType:(KBRKBeerType *)beerType;
@end

@interface KBRKBeerTypeEditViewController : KBUIFormViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverControllerDelegate, KBRKBrewersViewControllerDelegate,
KBRKBeerStylesViewControllerDelegate> { 
  KBUIFormTextField *nameField_;
  KBUIFormListSelect *brewerField_;
  KBUIFormListSelect *styleField_;
  KBUIFormTextField *abvField_;

  NSString *beerEditId_;
  KBUIFormTextField *imageNameField_;
  UIPopoverController *_imagePickerPopoverController;
}

@property (assign, nonatomic) id<KBRKBeerTypeEditViewControllerDelegate> delegate;

- (id)initWithTitle:(NSString *)title;

- (void)setBeerType:(KBRKBeerType *)beerType;

@end

//
//  KBKegTimeHostEditViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 8/3/11.
//  Copyright 2010 Yelp. All rights reserved.
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
#import "KBKegTimeHost.h"


@class KBKegTimeHostEditViewController;

@protocol KBKegTimeHostEditViewControllerDelegate <NSObject>
- (void)kegTimeHostEditViewController:(KBKegTimeHostEditViewController *)kegTimeHostEditViewController didAddHost:(KBKegTimeHost *)host;
@end


@interface KBKegTimeHostEditViewController : KBUIFormViewController {
  KBUIFormTextField *_nameField;
  KBUIFormTextField *_addressField;
  KBUIFormTextField *_portField;
  
  id<KBKegTimeHostEditViewControllerDelegate> _delegate;
}

@property (assign, nonatomic) id<KBKegTimeHostEditViewControllerDelegate> delegate;

@end

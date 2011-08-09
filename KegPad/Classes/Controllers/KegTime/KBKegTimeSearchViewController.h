//
//  KBKegTimeSearchViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBUIFormViewController.h"

#import "PBRServiceBrowser.h"
#import "KBUIFormTextField.h"
#import "KegTimeHostEditViewController.h"


@class KBKegTimeSearchViewController;


@interface KBKegTimeSearchNavigationController : UINavigationController {
  KBKegTimeSearchViewController *kegTimeSearchViewController_;
}

@property (retain, nonatomic) KBKegTimeSearchViewController *kegTimeSearchViewController;

@end


@interface KBKegTimeSearchViewController : KBUIFormViewController <PBRServiceBrowserDelegate, KegTimeHostEditViewControllerDelegate> {
  PBRServiceBrowser *_searchService;
  
  UILabel *_footerLabel;
}

@end

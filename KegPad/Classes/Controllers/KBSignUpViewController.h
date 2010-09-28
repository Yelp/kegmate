//
//  KBSignUpViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

@class KBSignUpViewController;

@protocol KBSignUpViewControllerDelegate <NSObject>
- (void)signUpViewControllerDidCancel:(KBSignUpViewController *)signUpViewController;
@end

@interface KBSignUpViewController : UIViewController {
  id<KBSignUpViewControllerDelegate> delegate_;
}

@property (assign, nonatomic) id<KBSignUpViewControllerDelegate> delegate;

@end

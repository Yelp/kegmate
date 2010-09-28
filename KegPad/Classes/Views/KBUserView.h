//
//  KBUserView.h
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBUser.h"

@interface KBUserView : UIView {
  UIImageView *imageView_;
  UIImageView *userImageView_;
  UILabel *displayNameLabel_;
  
  KBUser *user_;
}

@property (retain, nonatomic) KBUser *user;

@end

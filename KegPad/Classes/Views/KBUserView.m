//
//  KBUserView.m
//  KegPad
//
//  Created by Gabriel Handford on 9/27/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBUserView.h"


@implementation KBUserView

@synthesize user=user_;

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    self.userInteractionEnabled = NO;
    imageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beer.png"]];
    imageView_.contentMode = UIViewContentModeCenter;
    imageView_.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:imageView_];
    userImageView_ = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"beer_logged_in.png"]];
    userImageView_.contentMode = UIViewContentModeCenter;
    userImageView_.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    userImageView_.alpha = 0.0;
    [self addSubview:userImageView_];
    displayNameLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 20)];
    displayNameLabel_.font = [UIFont fontWithName:@"Baskerville-BoldItalic" size:32.0];
    displayNameLabel_.textColor = [UIColor whiteColor];
    displayNameLabel_.backgroundColor = [UIColor clearColor];
    displayNameLabel_.lineBreakMode = UILineBreakModeTailTruncation;
    displayNameLabel_.textAlignment = UITextAlignmentCenter;
    displayNameLabel_.alpha = 0.0;
    displayNameLabel_.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -0.06);
    [self addSubview:displayNameLabel_];
  }
  return self;
}

- (void)dealloc {
  [user_ release];
  [imageView_ release];
  [userImageView_ release];
  [displayNameLabel_ release];
  [super dealloc];
}

- (void)setUser:(KBUser *)user {
  [user_ retain];
  [user release];
  user_ = user;  
  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.5];
  if (user_) {
    imageView_.alpha = 0.0;
    userImageView_.alpha = 1.0;
    displayNameLabel_.alpha = 1.0;
    displayNameLabel_.text = user_.displayName;
  } else {
    imageView_.alpha = 1.0;
    userImageView_.alpha = 0.0;
    displayNameLabel_.alpha = 0.0;
  }
  [UIView commitAnimations];
  
  [self setNeedsDisplay];
}

@end

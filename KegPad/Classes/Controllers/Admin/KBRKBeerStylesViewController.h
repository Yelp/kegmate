//
//  KBRKBeerStylesViewController.h
//  KegPad
//
//  Created by John Boiles on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKViewController.h"
#import "KBRKBeerStyle.h"

@class KBRKBeerStylesViewController;

@protocol KBRKBeerStylesViewControllerDelegate <NSObject>
- (void)beerStylesViewController:(KBRKBeerStylesViewController *)beerStylesViewController didSelectBeerStyle:(KBRKBeerStyle *)beerStyle;
@end

@interface KBRKBeerStylesViewController : KBRKViewController {
  id<KBRKBeerStylesViewControllerDelegate> delegate_;
}

@property (assign, nonatomic) id<KBRKBeerStylesViewControllerDelegate> delegate;

@end

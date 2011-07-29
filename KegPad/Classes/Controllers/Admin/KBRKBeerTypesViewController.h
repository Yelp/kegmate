//
//  KBRKBeerTypesViewController.h
//  KegPad
//
//  Created by John Boiles on 5/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
//  Not filling this out yet since there isn't an api to get beer types

#import "KBRKViewController.h"
#import "KBRKBeerType.h"
#import "KBRKBeerTypeEditViewController.h"

@class KBRKBeerTypesViewController;

@protocol KBRKBeerTypesViewControllerDelegate <NSObject>
- (void)beerTypesViewController:(KBRKBeerTypesViewController *)beerTypesViewController didSelectBeerType:(KBRKBeerType *)beerType;
@end

@interface KBRKBeerTypesViewController : KBRKViewController <KBRKBeerTypeEditViewControllerDelegate> {
  id<KBRKBeerTypesViewControllerDelegate> delegate_;
}

@property (assign, nonatomic) id<KBRKBeerTypesViewControllerDelegate> delegate;

@end

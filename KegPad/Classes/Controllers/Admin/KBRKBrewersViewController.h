//
//  KBRKBrewersViewController.h
//  KegPad
//
//  Created by John Boiles on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KBRKViewController.h"
#import "KBRKBrewer.h"

@class KBRKBrewersViewController;

@protocol KBRKBrewersViewControllerDelegate <NSObject>
- (void)brewersViewController:(KBRKBrewersViewController *)brewersViewController didSelectBrewer:(KBRKBrewer *)brewer;
@end

@interface KBRKBrewersViewController : KBRKViewController {
  id delegate_;
}

@property (assign, nonatomic) id<KBRKBrewersViewControllerDelegate>delegate;

@end

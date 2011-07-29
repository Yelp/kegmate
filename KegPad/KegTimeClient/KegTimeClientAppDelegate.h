//
//  KegTimeClientAppDelegate.h
//  KegTimeClient
//
//  Created by Gabriel Handford on 7/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KBKegTimeSearchViewController.h"

@interface KegTimeClientAppDelegate : NSObject <UIApplicationDelegate> {
  KBKegTimeSearchNavigationController *_viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

//
//  KBRestKitViewController.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>


@interface KBRKViewController : UITableViewController <RKObjectLoaderDelegate> {
  NSArray *_objects;
}

@end

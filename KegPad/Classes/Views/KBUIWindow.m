//
//  KBUIWindow.m
//  KegPad
//
//  Created by Gabe on 10/7/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIWindow.h"

#import "KBNotifications.h"
#import "KBApplication.h"

static const NSTimeInterval kMaxActivityNotificationInterval = 1.0; // Max interval between activity notifications

@implementation KBUIWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
  // Secret 5 touch
  if ([[event allTouches] count] == 5) {
    [[KBApplication kegManager] loginWithTagId:@"ADMIN"];
  }
  
  if ([NSDate timeIntervalSinceReferenceDate] - _lastActivityTime > kMaxActivityNotificationInterval) {  
    _lastActivityTime = [NSDate timeIntervalSinceReferenceDate];
    KBDebug(@"Activity");
    [[NSNotificationCenter defaultCenter] postNotificationName:KBActivityNotification object:nil];
  }
  return [super hitTest:point withEvent:event];
}

@end

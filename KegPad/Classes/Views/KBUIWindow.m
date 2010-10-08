//
//  KBUIWindow.m
//  KegPad
//
//  Created by Gabe on 10/7/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIWindow.h"

#import "KBNotifications.h"

static const NSTimeInterval kMaxActivityNotificationInterval = 1.0; // Max interval between activity notifications

@implementation KBUIWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {  
  if ([NSDate timeIntervalSinceReferenceDate] - _lastActivityTime > kMaxActivityNotificationInterval) {  
    _lastActivityTime = [NSDate timeIntervalSinceReferenceDate];
    KBDebug(@"Activity");
    [[NSNotificationCenter defaultCenter] postNotificationName:KBActivityNotification object:nil];
  }
  return [super hitTest:point withEvent:event];
}

@end

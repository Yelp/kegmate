//
//  KBRecentPoursView.m
//  KegPad
//
//  Created by Gabriel Handford on 7/29/10.
//  Copyright 2010 Yelp. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "KBRecentPoursView.h"

#import "KBKegPour.h"
#import "KBUser.h"

@implementation KBRecentPoursView

- (void)dealloc {
  [recentPours_ release];
  [super dealloc];
}

- (void)setRecentPours:(NSArray *)recentPours {
  [recentPours retain];
  [recentPours_ release];
  recentPours_ = recentPours;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  CGPoint p = CGPointMake(10, 10);
  UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:24];
  UIFont *amountFont = [UIFont fontWithName:@"Helvetica" size:16];
  
  for (KBKegPour *pour in recentPours_) {
    NSString *name = [pour.user displayName];
    if (!name) name = @"Lone Drinker";
    [[UIColor whiteColor] set];
    [name drawAtPoint:p forWidth:160 withFont:nameFont lineBreakMode:UILineBreakModeTailTruncation];
    
    [[UIColor colorWithWhite:0.9 alpha:0.9] set];
    p.x += 168;
    [[pour amountDescriptionWithTimeAgo] drawAtPoint:CGPointMake(p.x, p.y + 5) forWidth:(self.frame.size.width - p.x)  withFont:amountFont lineBreakMode:UILineBreakModeTailTruncation];
    p.x = 10;
    p.y += 36;
  }
}

@end

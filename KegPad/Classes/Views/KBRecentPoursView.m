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
#import "KBRKDrink.h"
#import "KBUser.h"
#import "KBCGUtils.h"

#define kDefaultUserName @"Lone Drinker"


@implementation KBRecentPoursView

- (void)dealloc {
  [recentPours_ release];
  [super dealloc];
}

- (void)setRecentPours:(NSArray *)recentPours {
  // TODO(johnb): Ghetto, fix me
  RKObjectManager* objectManager = [RKObjectManager sharedManager];
  RKObjectMapping *drinkMapping = [objectManager.mappingProvider objectMappingForKeyPath:@"drink"];
  [objectManager loadObjectsAtResourcePath:@"/drinks" objectMapping:drinkMapping delegate:self];

  //[recentPours retain];
  //[recentPours_ release];
  //recentPours_ = recentPours;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGPoint point = CGPointMake(10, 10);
  UIFont *nameFont = [UIFont fontWithName:@"Helvetica-Bold" size:22];
  UIFont *amountFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
  
  for (KBRKDrink *drink in recentPours_) {
    NSString *name = drink.userId;
    if (!name) name = kDefaultUserName;

    // TODO(gabe): Use CATextLayer or cells instead of ghetto shadow
    [[UIColor colorWithWhite:0.0 alpha:0.9] set];
    [name drawAtPoint:CGPointMake(point.x, point.y + 1.0) forWidth:160 withFont:nameFont lineBreakMode:UILineBreakModeTailTruncation];
    [[UIColor colorWithWhite:0.9 alpha:0.9] set];
    [name drawAtPoint:point forWidth:160 withFont:nameFont lineBreakMode:UILineBreakModeTailTruncation];
    
    point.x += 168;
    [[UIColor colorWithWhite:1.0 alpha:0.5] set];
    [[drink amountDescriptionWithTimeAgo] drawInRect:CGRectMake(point.x, point.y + 4.5, self.frame.size.width - point.x - 10, 20) 
                                           withFont:amountFont lineBreakMode:UILineBreakModeTailTruncation 
                                          alignment:UITextAlignmentRight];
    [[UIColor colorWithWhite:0.0 alpha:0.8] set];
    [[drink amountDescriptionWithTimeAgo] drawInRect:CGRectMake(point.x, point.y + 4.0, self.frame.size.width - point.x - 10, 20) 
                                           withFont:amountFont lineBreakMode:UILineBreakModeTailTruncation 
                                          alignment:UITextAlignmentRight];
    point.x = 10;
    point.y += 32;
        
    extern void KBCGContextDrawLine(CGContextRef context, CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGColorRef color, CGFloat lineWidth);
    
    KBCGContextDrawLine(context, 0, point.y + 0.5, self.frame.size.width, point.y + 0.5, [UIColor colorWithWhite:1.0 alpha:0.8].CGColor, 0.5);
    KBCGContextDrawLine(context, 0, point.y, self.frame.size.width, point.y, [UIColor colorWithWhite:0.0 alpha:0.8].CGColor, 0.5);
    
    point.y += 4;
  }
}

- (void)objectLoader:(RKObjectLoader*)objectLoader didFailWithError:(NSError*)error {}

- (void)objectLoader:(RKObjectLoader*)objectLoader didLoadObjects:(NSArray*)objects {
  [objects retain];
  [recentPours_ release];
  recentPours_ = objects;
  [self setNeedsDisplay];
}

@end

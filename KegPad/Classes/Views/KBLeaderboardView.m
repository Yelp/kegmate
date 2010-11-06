//
//  KBLeaderboardView.m
//  KegPad
//
//  Created by Gabriel Handford on 7/30/10.
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

#import "KBLeaderboardView.h"

#import "KBCGUtils.h"
#import "KBPourIndex.h"


@implementation KBLeaderboardView

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    backgroundImage_ = [[UIImage imageNamed:@"literboard_background.png"] retain];
  }
  return self;
}

- (void)dealloc {
  [pourIndexes_ release];
  [backgroundImage_ release];
  [super dealloc];
}

- (void)setPourIndexes:(NSArray *)pourIndexes {
  [pourIndexes retain];
  [pourIndexes_ release];
  pourIndexes_ = pourIndexes;
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  [backgroundImage_ drawAtPoint:CGPointMake(0, 0)];
  
  CGPoint origin = CGPointMake(20, 20);
  CGPoint p = origin;
  UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:22];
  UIFont *amountFont = [UIFont fontWithName:@"Helvetica" size:15];
  
  CGFloat nameHeight = 24;
  CGFloat amountHeight = 26;
  CGFloat padding = 8;  
  CGFloat rowHeight = nameHeight + amountHeight + padding;
  
  for (KBPourIndex *pourIndex in pourIndexes_) {
    NSString *name = [pourIndex.user displayName];
    [[UIColor colorWithWhite:0.1 alpha:0.9] set];
    [name drawAtPoint:p forWidth:160 withFont:nameFont lineBreakMode:UILineBreakModeTailTruncation];
    
    [[UIColor colorWithWhite:0.2 alpha:0.8] set];
    p.y += nameHeight;
    [[pourIndex pouredDescription] drawAtPoint:CGPointMake(p.x, p.y) forWidth:(self.frame.size.width - p.x) 
                                      withFont:amountFont lineBreakMode:UILineBreakModeTailTruncation];
    p.y += amountHeight;
    
    KBCGContextDrawLine(context, p.x, p.y, self.frame.size.width - p.x, p.y, [UIColor whiteColor].CGColor, 0.5);
    KBCGContextDrawLine(context, p.x, p.y + 0.25, self.frame.size.width - p.x, p.y + 0.25, [UIColor colorWithWhite:0.2 alpha:0.8].CGColor, 0.25);
    
    // Check if we have room to draw next user
    if ((p.y + rowHeight) > self.frame.size.height)
      break;
    
    p.y += padding;
  }

}

@end

//
//  KBChartView.m
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

#import "KBChartView.h"

#import "KBDataStore.h"
#import "KBPourIndex.h"
#import "KBNotifications.h"
#import "KBApplication.h"
#import "KBCGUtils.h"


@implementation KBChartView

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    backgroundImage_ = [[UIImage imageNamed:@"graph_background.png"] retain];
    timeType_ = KBPourIndexTimeTypeMinutes15;
    legendXText_ = @"6 hour participation";
  }
  return self;
}

- (void)dealloc {
  [backgroundImage_ release];
  [legendXText_ release];
  [super dealloc];
}

- (void)recompute {
  NSInteger endIndex = [KBDataStore timeIndexForForDate:[NSDate date] timeType:timeType_];
  NSInteger startIndex = endIndex - kChunks;
  NSArray *pourIndexes = [[KBApplication dataStore] pourIndexesForStartIndex:startIndex endIndex:endIndex 
                                                                    timeType:timeType_ keg:nil user:nil error:nil];
  
  // TODO(gabe): Use memset
  for (NSInteger i = 0; i < kChunks; i++)
    values_[i] = 0;

  maxValue_ = 0.0;
  for (KBPourIndex *pourIndex in pourIndexes) {
    float value = (float)pourIndex.volumePouredValue;
    if (value > maxValue_) maxValue_ = value;
    NSInteger index = pourIndex.timeIndexValue - startIndex - 1;
    if (index >= 0 && index < kChunks) {      
      values_[index] = value;
    } else {
      KBError(@"Pour index out of bounds: %d", index);
    }
  }
  
  // Miniumum max value is X liters
  // TODO(gabe): Should this be keg total volume?
  if (maxValue_ < 25.0) maxValue_ = 25.0;
  
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  [backgroundImage_ drawAtPoint:CGPointMake(0, 0)];
  
  CGFloat padding = 10;
  CGFloat legendXHeight = 10;
  CGFloat legendYWidth = 0;
  
  CGFloat unitWidth = (self.frame.size.width - (padding * 2) - legendYWidth) / (float)kChunks;
  CGFloat maxHeight = (self.frame.size.height - (padding * 3)) - legendXHeight - 5; 
  
  // Origin at bottom left  
  CGPoint origin = CGPointMake(padding, self.frame.size.height - padding);
  CGPoint p = origin;
  UIColor *grayColor = [UIColor colorWithWhite:0.5 alpha:1.0];
  
  // Legend X
  [grayColor set];
  p.y -= legendXHeight;
  [legendXText_ drawAtPoint:CGPointMake(p.x + 570, p.y) withFont:[UIFont systemFontOfSize:10]];
  
  // Legend Y
  // TODO(gabe): Draw Y-axis legend
  p.x += legendYWidth;
  
  // Draw x-axis
  [grayColor set];
  for (NSInteger i = 0; i < kChunks; i++) {
    CGContextFillRect(context, CGRectMake(p.x + 1, p.y - 2.0, unitWidth - 2, 2.0));
    p.x += unitWidth;
  }
  
  // Reset to origin
  p = origin;
  p.x += legendYWidth;
  
  // Draw values
  [[UIColor colorWithRed:0.275 green:0.514 blue:0.698 alpha:1.0] set];
  for (NSInteger i = 0; i < kChunks; i++) {
    float percentage = values_[i] / maxValue_;
    CGFloat height = percentage * maxHeight;
    CGContextFillRect(context, CGRectMake(p.x + 1, p.y - 15.0, unitWidth - 2, -height));
    p.x += unitWidth;
  }
}


@end

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

#import "KBTypes.h"
#import "KBDataStore.h"
#import "KBKegPour.h"
#import "KBNotifications.h"
#import "KBApplication.h"

@implementation KBChartView

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"graph_background.png"]];
    background.contentMode = UIViewContentModeBottom;
    [self addSubview:background];
    [background release];
    
    graphView_ = [[S7GraphView alloc] init];
    graphView_.dataSource = self;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMaximumFractionDigits:2];
    
    graphView_.yValuesFormatter = numberFormatter;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:kCFDateFormatterShortStyle];
    [dateFormatter setDateStyle:kCFDateFormatterNoStyle];
    
    graphView_.xValuesFormatter = dateFormatter;
    
    [dateFormatter release];        
    [numberFormatter release];
    
    graphView_.backgroundColor = [UIColor clearColor];
    
    graphView_.drawAxisX = YES;
    graphView_.drawAxisY = YES;
    graphView_.drawGridX = YES;
    graphView_.drawGridY = YES;
    
    graphView_.xValuesColor = [UIColor blackColor];
    graphView_.yValuesColor = [UIColor blackColor];
    
    graphView_.gridXColor = [UIColor clearColor];
    graphView_.gridYColor = [UIColor clearColor];
    
    [self addSubview:graphView_];
    [graphView_ reloadData];
  }
  return self;
}

- (void)dealloc {
  [graphView_ release];
  [kegPourRates_ release];
  [kegPourDates_ release];
  [super dealloc];
}

- (void)layoutSubviews {
  [super layoutSubviews];  
  graphView_.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)_kegDidSavePour:(NSNotification *)notification {
  [self recompute];
}

- (void)recompute {
  NSArray *kegPours = [[KBApplication dataStore] recentKegPours:20 ascending:NO error:nil];
  
  if (!kegPourRates_)
    kegPourRates_ = [[NSMutableArray alloc] initWithCapacity:[kegPours count]];
  [kegPourRates_ removeAllObjects];
  if (!kegPourDates_) 
    kegPourDates_ = [[NSMutableArray alloc] initWithCapacity:[kegPours count]];
  [kegPourDates_ removeAllObjects];
  for (KBKegPour *kegPour in [kegPours reverseObjectEnumerator]) {
    [kegPourRates_ addObject:[NSNumber numberWithFloat:[kegPour amountValue] * kLitersToOunces]];
    [kegPourDates_ addObject:[kegPour date]];
  }
  [graphView_ reloadData];
}

#pragma mark DataSource (S7GraphViewDataSource)

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	return kegPourDates_;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
  return kegPourRates_;
}

@end

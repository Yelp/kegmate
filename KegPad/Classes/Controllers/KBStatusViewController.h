//
//  KBStatusViewController.h
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

#import "KBKeg.h"
#import "KBKegPour.h"
#import "KBKegTemperature.h"
#import "KBChartView.h"
#import "KBLeaderboardView.h"

/*!
 Status (back) display for KegPad.
 Loads via KBStatusViewController.xib.
 */
@interface KBStatusViewController : UIViewController {
  UILabel *nameLabel_;
  UILabel *lastPourTimeLabel_;
  UILabel *lastPourTimeUnitsLabel_;
  UILabel *lastPourAmountLabel_;
  UILabel *lastPourAmountUnitsLabel_;
  UILabel *percentRemaingLabel_;
  UILabel *temperatureLabel_;
  UILabel *temperatureDescriptionLabel_;
  UILabel *totalPouredAmountLabel_;
  
  KBChartView *chartView_;
  
  KBLeaderboardView *leaderboardView_;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastPourTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastPourTimeUnitsLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastPourAmountLabel;
@property (nonatomic, retain) IBOutlet UILabel *lastPourAmountUnitsLabel;
@property (nonatomic, retain) IBOutlet UILabel *percentRemaingLabel;
@property (nonatomic, retain) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, retain) IBOutlet UILabel *temperatureDescriptionLabel;
@property (nonatomic, retain) IBOutlet UILabel *totalPouredAmountLabel;
@property (nonatomic, retain) IBOutlet KBChartView *chartView;
@property (nonatomic, retain) IBOutlet KBLeaderboardView *leaderboardView;


- (void)updateKeg:(KBKeg *)keg ;

- (void)setLastKegPour:(KBKegPour *)kegPour;

- (void)setKegTemperature:(KBKegTemperature *)kegTemperature;

- (void)updateLeaderboard;

- (void)updateChart;

@end

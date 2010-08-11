//
//  KBStatusViewController.m
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

#import "KBStatusViewController.h"

#import "KBNotifications.h"

#import "KBDataStore.h"
#import "KBApplication.h"

@implementation KBStatusViewController

@synthesize nameLabel=nameLabel_, lastPourTimeLabel=lastPourTimeLabel_, lastPourTimeUnitsLabel=lastPourTimeUnitsLabel_,
lastPourAmountLabel=lastPourAmountLabel_, lastPourAmountUnitsLabel=lastPourAmountUnitsLabel_,
percentRemaingLabel=percentRemaingLabel_, totalPouredAmountLabel=totalPouredAmountLabel_,
temperatureLabel=temperatureLabel_, temperatureDescriptionLabel=temperatureDescriptionLabel_,
chartView=chartView_, leaderboardView=leaderboardView_;

- (id)init {  
  if ((self = [super initWithNibName:nil bundle:nil])) { }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [nameLabel_ release];
  [lastPourTimeLabel_ release];
  [lastPourTimeUnitsLabel_ release];
  [lastPourAmountLabel_ release];
  [lastPourAmountUnitsLabel_ release];
  [percentRemaingLabel_ release];
  [totalPouredAmountLabel_ release];
  [temperatureLabel_ release];
  [temperatureDescriptionLabel_ release];
  [chartView_ release];
  [leaderboardView_ release];
  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegTemperatureDidChange:) name:KBKegTemperatureDidChangeNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegVolumeDidChange:) name:KBKegVolumeDidChangeNotification object:nil];    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidStartPour:) name:KBKegDidStartPourNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidEndPour:) name:KBKegDidEndPourNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidSavePour:) name:KBKegDidSavePourNotification object:nil];      
}

- (void)updateLeaderboard {
  [leaderboardView_ setUsers:[[KBApplication dataStore] topUsersByPourWithOffset:0 limit:6 error:nil]];
}

- (void)updateChart {
  [chartView_ recompute];
}

- (void)updateKeg:(KBKeg *)keg {
  self.view;
  if (keg) {
    nameLabel_.text = keg.beer.name;
    percentRemaingLabel_.text = [NSString stringWithFormat:@"%0.0f", [keg volumeRemaingPercentage]];
    totalPouredAmountLabel_.text = [NSString stringWithFormat:@"%0.1f liters", [keg volumeTotalPouredAdjustedValue]];
  } else { 
    nameLabel_.text = @"";
    percentRemaingLabel_.text = @"";
    totalPouredAmountLabel_.text = @"-";
  }
}  

- (void)setLastKegPour:(KBKegPour *)kegPour {
  self.view;
  if (kegPour) {
    NSDate *date = [kegPour date];
    lastPourTimeLabel_.text = [NSString stringWithFormat:@"%d", [kegPour timeAgoInteger:date]];
    lastPourTimeUnitsLabel_.text = [kegPour timeAgoUnitsDescription:date];
    lastPourAmountLabel_.text = [kegPour amountValueDescriptionInOunces];
    lastPourAmountUnitsLabel_.text = @"OUNCES";
  } else {
    lastPourTimeLabel_.text = @"-";
    lastPourTimeUnitsLabel_.text = @"-";
    lastPourAmountLabel_.text = @"-";
    lastPourAmountUnitsLabel_.text = @"-";
  }
}

- (void)setKegTemperature:(KBKegTemperature *)kegTemperature {
  self.view;
  if (kegTemperature) {
    temperatureLabel_.text = [NSString stringWithFormat:@"%0.1f°C", [kegTemperature temperatureValue]];
    temperatureDescriptionLabel_.text = [kegTemperature statusDescription];
  } else {
    temperatureLabel_.text = @"-";
    temperatureDescriptionLabel_.text = @"TEMP.";
  }  
}

#pragma mark - 

- (void)_kegTemperatureDidChange:(NSNotification *)notification {
  [self setKegTemperature:[notification object]];
}

- (void)_kegVolumeDidChange:(NSNotification *)notification {
  [self updateKeg:[notification object]];
}

- (void)_kegDidStartPour:(NSNotification *)notification {

}

- (void)_kegDidEndPour:(NSNotification *)notification {

}

- (void)_kegDidSavePour:(NSNotification *)notification {
  [self setLastKegPour:[notification object]];
  [self updateLeaderboard];
  [self updateChart];
}

@end

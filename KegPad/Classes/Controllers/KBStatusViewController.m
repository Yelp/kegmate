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
#import "KBApplicationDelegate.h"


@implementation KBStatusViewController

@synthesize nameLabel=nameLabel_, lastPourTimeLabel=lastPourTimeLabel_, lastPourTimeUnitsLabel=lastPourTimeUnitsLabel_,
lastPourAmountLabel=lastPourAmountLabel_, lastPourAmountUnitsLabel=lastPourAmountUnitsLabel_,
percentRemaingLabel=percentRemaingLabel_, totalPouredAmountLabel=totalPouredAmountLabel_,
temperatureLabel=temperatureLabel_, temperatureDescriptionLabel=temperatureDescriptionLabel_,
chartView=chartView_, leaderboardView=leaderboardView_, delegate=delegate_, flowIndicator=flowIndicator_;

- (id)init {  
  if ((self = [super initWithNibName:nil bundle:nil])) {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"KBFlowIndicator" owner:nil options:nil];
    for (id currentObject in topLevelObjects) {
      if ([currentObject isKindOfClass:[KBFlowIndicator class]]) {
        self.flowIndicator = currentObject;
        break;
      }
    }
    self.flowIndicator.frame = CGRectMake(20, 331, 402, 350);
    [self.view addSubview:self.flowIndicator];
  }
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
  [flowIndicator_ release];
  [keg_ release];
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_beerDidEdit:) name:KBBeerDidEditNotification object:nil];    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidEdit:) name:KBKegDidEditNotification object:nil];      
}

- (void)updateLeaderboard {
  NSArray *pourIndexes = [[KBApplication dataStore] topVolumePourIndexesWithOffset:0 limit:6 timeType:KBPourIndexTimeTypeDay error:nil];
  [leaderboardView_ setPourIndexes:pourIndexes];
}

- (void)updateChart {
  [chartView_ recompute];
}

- (void)updateBeer:(KBBeer *)beer {
  if (beer) {
    nameLabel_.text = beer.name;
  } else {
    nameLabel_.text = @"";
  }
}

- (void)updateKeg:(KBKeg *)keg {
  self.view;
  [keg retain];
  [keg_ release];
  keg_ = keg;
  if (keg) {
    percentRemaingLabel_.text = [NSString stringWithFormat:@"%0.0f", [keg volumeRemaingPercentage]];
    totalPouredAmountLabel_.text = [NSString stringWithFormat:@"%0.1f liters", [keg volumeTotalPouredAdjustedValue]];
  } else {     
    percentRemaingLabel_.text = @"";
    totalPouredAmountLabel_.text = @"-";
  }
  [self updateBeer:keg.beer];
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
    temperatureLabel_.text = [kegTemperature temperatureDescription];
    temperatureDescriptionLabel_.text = [kegTemperature statusDescription];
  } else {
    temperatureLabel_.text = @"-";
    temperatureDescriptionLabel_.text = @"TEMP.";
  }  
}

- (IBAction)flip:(id)sender {
  [delegate_ flip];
}

#pragma mark - 

- (void)_beerDidEdit:(NSNotification *)notification {
  // Update if the beer is in the current keg
  KBBeer *beer = [notification object];
  if ([keg_.beer isEqual:beer])
    [self updateBeer:beer];
}

- (void)_kegDidEdit:(NSNotification *)notification {
  KBKeg *keg = [notification object];
  if (keg_ == keg) 
    [self updateKeg:keg];
}

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

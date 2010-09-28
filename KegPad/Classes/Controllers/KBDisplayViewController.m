//
//  KBDisplayViewController.m
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

#import "KBDisplayViewController.h"

#import "KBDataStore.h"
#import "KBNotifications.h"
#import "KBApplication.h"

@implementation KBDisplayViewController

@synthesize beerMovieView=beerMovieView_, nameLabel=nameLabel_, infoLabel=infoLabel_, abvLabel=abvLabel_, imageView=imageView_, 
temperatureLabel=temperatureLabel_, typeLabel=typeLabel_, countryLabel=countryLabel_,
tempDescriptionLabel=tempDescriptionLabel_, chalkCircleView=chalkCircleView_, recentPoursView=recentPoursView_, 
ratingPicker=ratingPicker_, userView=userView_;

- (id)init {
  if ((self = [super initWithNibName:nil bundle:nil])) { }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [timer_ release];
  [timer_ invalidate];
  [beerMovieView_ release];
  [adminViewController_ release];
  [nameLabel_ release];
  [infoLabel_ release];
  [abvLabel_ release];
  [imageView_ release];
  [temperatureLabel_ release];
  [typeLabel_ release];
  [countryLabel_ release];
  [tempDescriptionLabel_ release];
  [chalkCircleView_ release];
  [recentPoursView_ release];
  [ratingPicker_ release];
  [userView_ release];
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

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  timer_ = [[NSTimer timerWithTimeInterval:60 target:self selector:@selector(updateRecentPours) userInfo:nil repeats:YES] retain];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [timer_ invalidate];
  [timer_ release];
  timer_ = nil;
}

- (void)startPour {
  self.view;  
  beerMovieView_.alpha = 0.0;
  [self.view bringSubviewToFront:beerMovieView_];  
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.5];
  beerMovieView_.alpha = 1.0;
  [UIView commitAnimations];
  [beerMovieView_ play];
}

- (void)stopPour {
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:0.3];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(_stopAnimationDidStop:finished:context:)];
  beerMovieView_.alpha = 0.0;
  [UIView commitAnimations];
}

- (void)updateRecentPours {
  [recentPoursView_ setRecentPours:[[KBApplication dataStore] recentKegPours:6 ascending:NO error:nil]];
}

- (void)_stopAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  [beerMovieView_ stop];
  [self.view bringSubviewToFront:ratingPicker_];
}

- (IBAction)admin {
  if (!adminViewController_) adminViewController_ = [[KBAdminViewController alloc] init];
  [self presentModalViewController:adminViewController_ animated:YES];
}

- (void)_updateKegTemperatureValue:(float)temperature {
  // TODO(gabe): Fix all the absolute pixel math
  CGFloat chalkCircleOriginMinY = chalkCircleView_.frame.origin.y;
  CGFloat chalkCircleOriginMaxY = chalkCircleOriginMinY - (chalkCircleView_.frame.size.height/2.0) + 306; // Height of thermometer
  
  float percentage = ((temperature - [KBKegTemperature min]) / ([KBKegTemperature max] - [KBKegTemperature min]));
  CGFloat percentageToHeight = percentage * (chalkCircleOriginMaxY - chalkCircleOriginMinY);
  CGFloat temperatureY = percentageToHeight + chalkCircleOriginMinY;
  if (temperatureY < chalkCircleOriginMinY) temperatureY = chalkCircleOriginMinY;
  if (temperatureY > chalkCircleOriginMaxY) temperatureY = chalkCircleOriginMaxY;
  
  chalkCircleView_.hidden = NO;
  chalkCircleView_.frame = CGRectMake(chalkCircleView_.frame.origin.x, temperatureY,
                                      chalkCircleView_.frame.size.width, chalkCircleView_.frame.size.height);
  
  temperatureLabel_.text = [NSString stringWithFormat:@"%0.1f°C", temperature];
}

- (void)setKegTemperature:(KBKegTemperature *)kegTemperature {
  self.view;
  if (kegTemperature) {    
    tempDescriptionLabel_.hidden = NO;
    tempDescriptionLabel_.text = [kegTemperature thermometerDescription];
    [self _updateKegTemperatureValue:[kegTemperature temperatureValue]];
  } else {
    tempDescriptionLabel_.hidden = YES;
    chalkCircleView_.hidden = YES;
    temperatureLabel_.text = @" - °C";
  }
}

- (void)updateKeg:(KBKeg *)keg {
  self.view;
  if (keg.beer) {
    nameLabel_.text = keg.beer.name;
    infoLabel_.text = keg.beer.info;
    typeLabel_.text = keg.beer.type;
    countryLabel_.text = keg.beer.country;
    abvLabel_.text = [NSString stringWithFormat:@"%0.1f", keg.beer.abvValue];
    imageView_.image = [UIImage imageNamed:keg.beer.imageName];
  } else {
    nameLabel_.text = @"";
    infoLabel_.text = @"";
    typeLabel_.text = @"-";
    countryLabel_.text = @"-";
    abvLabel_.text = @"-";
    imageView_.image = nil;
  }
}

- (void)setUser:(KBUser *)user {
  [userView_ setUser:user];
}

#pragma mark - 

- (void)_kegTemperatureDidChange:(NSNotification *)notification {
  [self setKegTemperature:[notification object]];
}

- (void)_kegVolumeDidChange:(NSNotification *)notification {
  [self updateKeg:[notification object]];
}

- (void)_kegDidStartPour:(NSNotification *)notification {
  [self startPour];
}

- (void)_kegDidEndPour:(NSNotification *)notification {
  [self stopPour];
}

- (void)_kegDidSavePour:(NSNotification *)notification {
  [self updateRecentPours];
}

@end


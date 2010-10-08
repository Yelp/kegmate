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
#import "KBApplicationDelegate.h"
#import "KBTypes.h"
#import "KBRating.h"


@interface KBDisplayViewController ()
@property (retain, nonatomic) KBKeg *keg;
@property (retain, nonatomic) KBUser *user;
@end


@implementation KBDisplayViewController

@synthesize beerMovieView=beerMovieView_, nameLabel=nameLabel_, infoLabel=infoLabel_, abvLabel=abvLabel_, imageView=imageView_, 
temperatureLabel=temperatureLabel_, typeLabel=typeLabel_, countryLabel=countryLabel_,
tempDescriptionLabel=tempDescriptionLabel_, chalkCircleView=chalkCircleView_, recentPoursView=recentPoursView_, 
ratingPicker=ratingPicker_, rateButton=rateButton_, userView=userView_, delegate=delegate_;

@synthesize keg=keg_, user=user_; // Private properties

- (id)init {
  if ((self = [super initWithNibName:nil bundle:nil])) { }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [timer_ release];
  [timer_ invalidate];
  [keg_ release];
  [user_ release];
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
  [rateButton_ release];
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
  [self.view sendSubviewToBack:beerMovieView_];
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
  [self.view sendSubviewToBack:beerMovieView_];
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
  self.keg = keg;
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
  // Set rating if we are setting a new user
  // Save rating if we are unsetting the user
  if (keg_) {
    if (user) {
      KBRating *rating = [[KBApplication dataStore] ratingWithUser:user beer:keg_.beer error:nil];
      KBDebug(@"Loaded rating: %d for user: %@", rating.ratingValue, user.firstName);
      if (rating) {
        [ratingPicker_ setRating:(KBRatingValue)rating.ratingValue];
      } else {
        [ratingPicker_ setRating:KBRatingValueNone];
      }
    } else if (user_) {
      KBDebug(@"Saving rating: %d for user: %@", ratingPicker_.rating, user_.firstName);
      [[KBApplication dataStore] setRating:ratingPicker_.rating user:user_ beer:keg_.beer error:nil];
    }
  }
  
  [user retain];
  [user_ release];
  user_ = user;

  if (!user_) {
    // Hide rating button and picker
    rateButton_.userInteractionEnabled = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    rateButton_.alpha = 0.0;
    ratingPicker_.alpha = 0.0;
    [UIView commitAnimations];    
  } else if (keg_) {
    // Show rating button
    rateButton_.userInteractionEnabled = YES;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    rateButton_.alpha = 1.0;
    [UIView commitAnimations]; 
  }

  [userView_ setUser:user_];
}

#pragma mark Actions

- (IBAction)rateBeer:(id)sender {
  if (user_ && keg_) {
    // Show rating picker
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    ratingPicker_.alpha = 1.0;
    [UIView commitAnimations];    
  }
}

- (IBAction)admin:(id)sender {
  if (!adminViewController_) adminViewController_ = [[KBAdminViewController alloc] init];
  [self presentModalViewController:adminViewController_ animated:YES];
}

- (IBAction)flip:(id)sender {
  [delegate_ flip];
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


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
- (void)_updateKegTemperature:(KBKegTemperature *)kegTemperature;
@end


@implementation KBDisplayViewController

@synthesize beerMovieView=beerMovieView_, nameLabel=nameLabel_, infoLabel=infoLabel_, abvLabel=abvLabel_, imageView=imageView_, 
temperatureLabel=temperatureLabel_, typeLabel=typeLabel_, countryLabel=countryLabel_, rateLabel=rateLabel_, 
ratingCountLabel=ratingCountLabel_, tempDescriptionLabel=tempDescriptionLabel_, chalkCircleView=chalkCircleView_, 
recentPoursView=recentPoursView_,  ratingPicker=ratingPicker_, ratingView=ratingView_, userView=userView_, 
adminButton=adminButton_, delegate=delegate_;

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
  [rateLabel_ release];
  [temperatureLabel_ release];
  [typeLabel_ release];
  [countryLabel_ release];
  [tempDescriptionLabel_ release];
  [chalkCircleView_ release];
  [recentPoursView_ release];
  [ratingPicker_ release];
  [ratingView_ release];
  [ratingCountLabel_ release];
  [userView_ release];
  [adminButton_ release];
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
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userDidSetRating:) name:KBUserDidSetRatingNotification object:nil];    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_beerDidEdit:) name:KBBeerDidEditNotification object:nil];    
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_kegDidEdit:) name:KBKegDidEditNotification object:nil];      

  [self.view sendSubviewToBack:beerMovieView_];
  
  // TODO(gabe): Fix the pixel math
  chalkCircleOriginMinY_ = 30;
  chalkCircleOriginMaxY_ = chalkCircleOriginMinY_ - (chalkCircleView_.frame.size.height/2.0) + 306; // Height of thermometer  
  
#if TARGET_IPHONE_SIMULATOR
  adminButton_.hidden = NO;
#endif
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  timer_ = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateRecentPours) userInfo:nil repeats:YES] retain];
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
  [recentPoursView_ setRecentPours:[[KBApplication dataStore] recentKegPours:20 ascending:NO error:nil]];
}

- (void)_stopAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  [beerMovieView_ stop];
  [self.view sendSubviewToBack:beerMovieView_];
}

- (void)_updateKegTemperature:(KBKegTemperature *)kegTemperature {
  float temperature = [kegTemperature temperatureValue];
  float percentage = ((temperature - [KBKegTemperature min]) / ([KBKegTemperature max] - [KBKegTemperature min]));
  CGFloat percentageToHeight = percentage * (chalkCircleOriginMaxY_ - chalkCircleOriginMinY_);
  CGFloat temperatureY = percentageToHeight + chalkCircleOriginMinY_;
  if (temperatureY < chalkCircleOriginMinY_) temperatureY = chalkCircleOriginMinY_;
  if (temperatureY > chalkCircleOriginMaxY_) temperatureY = chalkCircleOriginMaxY_;
  
  chalkCircleView_.hidden = NO;
  chalkCircleView_.frame = CGRectMake(chalkCircleView_.frame.origin.x, temperatureY,
                                      chalkCircleView_.frame.size.width, chalkCircleView_.frame.size.height);
  
  temperatureLabel_.text = [kegTemperature temperatureDescription];
}

- (void)updateRatingFromBeer:(KBBeer *)beer {
  KBRatingValue ratingValue = KBRatingValueNone;
  NSInteger ratingCount = beer.ratingCountValue;
  if (ratingCount > 0) {
    double rating = beer.ratingTotalValue / (double)ratingCount;
    ratingValue = KBRatingValueFromRating(rating);
    KBDebug(@"Rating: %0.1f, %@ / %@", rating, beer.ratingTotal, beer.ratingCount);
  }
  
  if (ratingValue != KBRatingValueNone) {
    [ratingView_ setRating:ratingValue];
    if (ratingCount == 1) {
      ratingCountLabel_.text = [NSString stringWithFormat:@"(1 rating)"];
    } else {
      ratingCountLabel_.text = [NSString stringWithFormat:@"(%d ratings)", ratingCount];
    }
  } else {
    [ratingView_ setRating:KBRatingValueNone];
    ratingCountLabel_.text = @"";
  }
}

- (void)setKegTemperature:(KBKegTemperature *)kegTemperature {
  self.view;
  if (kegTemperature) {    
    tempDescriptionLabel_.hidden = NO;
    tempDescriptionLabel_.text = [kegTemperature thermometerDescription];
    [self _updateKegTemperature:kegTemperature];
  } else {
    tempDescriptionLabel_.hidden = YES;
    chalkCircleView_.hidden = YES;
    temperatureLabel_.text = @" - °C";
  }
}

- (void)updateBeer:(KBBeer *)beer {
  if (beer) {
    nameLabel_.text = beer.name;
    infoLabel_.text = beer.info;
    typeLabel_.text = beer.type;
    countryLabel_.text = beer.country;
    abvLabel_.text = [NSString stringWithFormat:@"%0.1f", beer.abvValue];
    imageView_.image = [UIImage imageNamed:beer.imageName];
  } else {
    nameLabel_.text = @"";
    infoLabel_.text = @"";
    typeLabel_.text = @"-";
    countryLabel_.text = @"-";
    abvLabel_.text = @"-";
    imageView_.image = nil;
  }  
  [self updateRatingFromBeer:beer];
}

- (void)updateKeg:(KBKeg *)keg {
  self.view;
  self.keg = keg;
  [self updateBeer:keg.beer];
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
      if ([ratingPicker_ isModified]) {
        KBDebug(@"Saving rating: %d for user: %@", ratingPicker_.rating, user_.firstName);
        [[KBApplication dataStore] setRating:ratingPicker_.rating user:user_ keg:keg_ error:nil];
      }
    }
  }
  
  [user retain];
  [user_ release];
  user_ = user;

  if (!user_) {
    // Hide rating and picker
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    rateLabel_.alpha = 0.0;
    ratingPicker_.alpha = 0.0;
    [UIView commitAnimations];    
  } else if (user_ && keg_) {
    // Show rating and picker
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    rateLabel_.alpha = 1.0;
    ratingPicker_.alpha = 1.0;
    [UIView commitAnimations]; 
  }

  adminButton_.hidden = ![user_ isAdminValue];

  [userView_ setUser:user_];
}

#pragma mark Actions

- (IBAction)admin:(id)sender {
  if (!adminViewController_) adminViewController_ = [[KBAdminViewController alloc] init];
  [self presentModalViewController:adminViewController_ animated:YES];
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
  [self updateKeg:[notification object]];
}

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

- (void)_userDidSetRating:(NSNotification *)notification {
  [self updateRatingFromBeer:keg_.beer];
}

@end


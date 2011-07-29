//
//  KBDisplayViewController.h
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

#import "KBBeerMovieView.h"
#import "KBBeer.h"
#import "KBRKThermoLog.h"
#import "KBRecentPoursView.h"
#import "KBRatingPicker.h"
#import "KBUserView.h"
#import "KBChalkLabel.h"

@class KBApplicationDelegate;

/*!
 Main display for KegPad.
 Loads via KBDisplayViewController.xib.
 */
@interface KBDisplayViewController : UIViewController {
  KBBeerMovieView *beerMovieView_; //! Movie view for when we are pouring
  
  UILabel *nameLabel_;
  UILabel *typeLabel_;
  UILabel *countryLabel_;
  UILabel *infoLabel_;
  UILabel *abvLabel_;
  UILabel *tempDescriptionLabel_;
  UIImageView *imageView_;
  
  KBRatingChalkView *ratingView_;
  KBChalkLabel *ratingCountLabel_;
  
  UIImageView *chalkCircleView_;
  UILabel *temperatureLabel_;
  UIButton *adminButton_;
  
  KBUserView *userView_;

  KBRecentPoursView *recentPoursView_;

  NSTimer *timer_; // For updating screen every minute
  
  UIImageView *rateLabel_;
  KBRatingPicker *ratingPicker_;
  
  KBKeg *keg_;
  KBUser *user_;
  
  CGFloat chalkCircleOriginMinY_;
  CGFloat chalkCircleOriginMaxY_;  
  
  KBApplicationDelegate *delegate_; // weak
}

@property (nonatomic, retain) IBOutlet KBBeerMovieView *beerMovieView;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UILabel *countryLabel;
@property (nonatomic, retain) IBOutlet UILabel *abvLabel;
@property (nonatomic, retain) IBOutlet UILabel *temperatureLabel;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet KBRatingChalkView *ratingView;
@property (nonatomic, retain) IBOutlet KBChalkLabel *ratingCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *tempDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIImageView *chalkCircleView;
@property (nonatomic, retain) IBOutlet KBRecentPoursView *recentPoursView;
@property (nonatomic, retain) IBOutlet UIImageView *rateLabel;
@property (nonatomic, retain) IBOutlet KBRatingPicker *ratingPicker;
@property (nonatomic, retain) IBOutlet KBUserView *userView;
@property (nonatomic, retain) IBOutlet UIButton *adminButton;

@property (nonatomic, assign) KBApplicationDelegate *delegate;

- (void)startPour;
- (void)stopPour;

- (IBAction)admin:(id)sender;
- (IBAction)flip:(id)sender;

- (void)updateKeg:(KBKeg *)keg;

- (void)setKegTemperature:(KBRKThermoLog *)kegTemperature;

- (void)updateRecentPours;

- (void)setUser:(KBUser *)user;

@end

//
//  KBRatingPicker.h
//  YelpIPhone
//
//  Created by Gabriel Handford on 3/10/09.
//  Copyright 2009 Yelp. All rights reserved.
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

#import "KBTypes.h"

enum {
  KBRatingPickerStyleDefault,
  KBRatingPickerStyleChalk,
};

typedef NSUInteger KBRatingPickerStyle;


/*!
 Control for picking a rating from 1 - 5 stars.
 Currently does not resize properly, use size of 300x63.
 */
@interface KBRatingPicker : UIControl {
	NSArray *starImages_;
	NSInteger starIndex_; // Index of current star image; -1 for None
	
	CGSize inset_;
	
	KBRatingValue rating_;
}

@property (assign, nonatomic) KBRatingValue rating;

- (id)initWithStyle:(KBRatingPickerStyle)style;

- (void)setStyle:(KBRatingPickerStyle)style;

@end


@interface KBRatingChalkView : KBRatingPicker {

}

@end
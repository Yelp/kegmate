//
//  KBTypes.h
//  KegPad
//
//  Created by John Boiles on 7/30/10.
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

#define kLitersToOunces 33.8140227
#define kOuncesToLiter 0.0295735296

enum {
  KBRatingValueUnknown = -1, //! For internal use only
  KBRatingValueNone = 0,
  KBRatingValue1 = 1,
  KBRatingValue2 = 2,
  KBRatingValue3 = 3,
  KBRatingValue4 = 4,
  KBRatingValue5 = 5
};
typedef NSInteger KBRatingValue;


extern KBRatingValue KBRatingValueFromRating(double rating);


enum {
  KBPourIndexTimeTypeHour = 1,
  KBPourIndexTimeTypeMinutes15 = 2,
};
typedef NSInteger KBPourIndexTimeType;

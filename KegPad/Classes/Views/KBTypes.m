//
//  KBTypes.m
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

#import "KBTypes.h"

extern KBRatingValue KBRatingValueFromRating(double rating) {
  if (rating < 0.5) return KBRatingValueNone;
  else if (rating >= 0.5 && rating < 1.5) return KBRatingValue1;
  else if (rating >= 1.5 && rating < 2.5) return KBRatingValue2;
  else if (rating >= 2.5 && rating < 3.5) return KBRatingValue3;
  else if (rating >= 3.5 && rating < 4.5) return KBRatingValue4;
  else if (rating >= 4.5) return KBRatingValue5;
  return KBRatingValueNone;
}
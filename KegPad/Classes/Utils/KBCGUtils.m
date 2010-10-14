//
//  KBCGUtils.m
//  KegPad
//
//  Created by Gabriel Handford on 10/13/10.
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

#import "KBCGUtils.h"


void KBCGContextDrawLine(CGContextRef context, CGFloat x1, CGFloat y1, CGFloat x2, CGFloat y2, CGColorRef color, CGFloat lineWidth) {
  CGContextBeginPath(context);
  CGContextMoveToPoint(context, x1, y1);
  CGContextAddLineToPoint(context, x2, y2);
  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, lineWidth);
  CGContextStrokePath(context);
}


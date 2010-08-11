//
//  KBRatingPicker.m
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

#import "KBRatingPicker.h"

@interface KBRatingPicker ()
- (NSInteger)_pointInsideIndex:(CGPoint)point; // Find index (1-5) for (touch) point
- (void)_selectWithTouches:(NSSet *)touches; // Update selected index from touches
@end
 
@implementation KBRatingPicker

@synthesize rating=rating_;

- (id)initWithCoder:(NSCoder *)coder {
  if ((self = [super initWithCoder:coder])) {
		// Images should be 268x49 which centers in 300x63 with (16x7 inset)
		// TODO(gabe): Add ability to draw at smaller sizes
		starImages_ = [[NSArray arrayWithObjects:
										[UIImage imageNamed:@"o0hstars_large@2x.png"],
										[UIImage imageNamed:@"o2hstars_large@2x.png"],
										[UIImage imageNamed:@"o4hstars_large@2x.png"],
										[UIImage imageNamed:@"o6hstars_large@2x.png"],
										[UIImage imageNamed:@"o8hstars_large@2x.png"],
										[UIImage imageNamed:@"o10hstars_large@2x.png"],
										nil] retain];
		rating_ = KBRatingValueNone;
		inset_ = CGSizeMake(16.0, 7.0);
		starIndex_ = 0;
		self.opaque = NO;
  }
  return self;
}

- (void)dealloc {
	[starImages_ release];
	[super dealloc];
}

- (NSInteger)_pointInsideIndex:(CGPoint)point {
	CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	frame = CGRectInset(frame, inset_.width, inset_.height);
	
	CGFloat divideWidth = frame.size.width/5.0;
	
	CGRect slice;
	NSInteger index = -1;
	for(NSInteger i = 0; i < 5; i++) {		
		CGRectDivide(frame, &slice, &frame, divideWidth, CGRectMinXEdge);
		if (CGRectContainsPoint(slice, point)) {
			index = i;
			break;
		}
	}
	return index;
}

- (void)_selectWithTouches:(NSSet *)touches {
	NSInteger selectedStars = 0;
	for(UITouch *touch in touches) {
		CGPoint point = [touch locationInView:self];
		NSInteger index = [self _pointInsideIndex:point];
		if (index != -1) {
			selectedStars = index + 1; // +1 since the index=0 position should be set to 1 star
			break;
		}
	}

	// If not in any region, but inside the element, then lets clear the selection
	self.rating = selectedStars;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _selectWithTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self _selectWithTouches:touches];
}

- (void)setRating:(KBRatingValue)rating {
	rating_ = rating;
	starIndex_ = rating;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (self.opaque) {
		CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
		CGContextFillRect(context, self.frame);
	}	
	
	CGRect bounds = self.bounds;
	
	UIImage *starImage = (starIndex_ >= 0 && starIndex_ < [starImages_ count]) ? [starImages_ objectAtIndex:starIndex_] : nil;
	if (starImage) {
    // TODO(johnb): Do an aspect fit here
		CGFloat xPad = inset_.width;
		CGFloat yPad = inset_.height;
    CGRect imageRect = CGRectMake(bounds.origin.x + xPad, bounds.origin.y + yPad, self.frame.size.width - 2 * (bounds.origin.x + xPad), self.frame.size.height - 2 * (bounds.origin.y + yPad));
		[starImage drawInRect:imageRect];	
	}
}

@end

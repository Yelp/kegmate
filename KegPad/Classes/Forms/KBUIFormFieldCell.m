//
//  KBUIFormFieldCell.m
//  KegPad
//
//  Created by Gabe on 9/28/10.
//  Copyright 2010 rel.me. All rights reserved.
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

#import "KBUIFormFieldCell.h"


@implementation KBUIFormFieldCell

@synthesize textField=textField_, editable=editable_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    textField_ = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
		textField_.clearsOnBeginEditing = NO;
		textField_.returnKeyType = UIReturnKeyDone;
		textField_.font = [UIFont systemFontOfSize:17];
		textField_.textColor = [UIColor darkGrayColor];
		textField_.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField_.autocorrectionType = UITextAutocorrectionTypeNo;
    // TODO(gabe): For password
    //textField_.secureTextEntry = YES;
		[self.contentView addSubview:textField_];
  }
  return self;
}

- (void)dealloc {
	[textField_ release];	
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];	

  CGSize labelSize = [self.textLabel sizeThatFits:self.bounds.size];

  CGFloat x = labelSize.width + 24;
  CGFloat y = 2 + roundf(self.contentView.bounds.size.height/2.0 - textField_.bounds.size.height/2.0);
  CGFloat width = self.contentView.bounds.size.width - x - 10;
  
  textField_.frame = CGRectMake(x, y, width, textField_.bounds.size.height);

//  switch_.frame = CGRectMake(self.contentView.bounds.size.width - switch_.bounds.size.width - 10,
//    roundf(self.contentView.bounds.size.height/2.0 - switch_.bounds.size.height/2.0),
//    switch_.bounds.size.width, switch_.bounds.size.height);

	[self.contentView bringSubviewToFront:textField_];
}

@end
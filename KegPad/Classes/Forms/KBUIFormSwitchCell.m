//
//  KBUIFormSwitchCell.m
//  KegPad
//
//  Created by Gabe on 10/10/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBUIFormSwitchCell.h"


@implementation KBUIFormSwitchCell

@synthesize switchField=switchField_;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
    switchField_ = [[UISwitch alloc] initWithFrame:CGRectZero];	
		[self.contentView addSubview:switchField_];
  }
  return self;
}

- (void)dealloc {
	[switchField_ release];
	[super dealloc];
}

- (void)layoutSubviews {
	[super layoutSubviews];	
  
  CGSize labelSize = [self.textLabel sizeThatFits:self.bounds.size];
  
  CGFloat x = labelSize.width + 24;
  CGFloat y = 2 + roundf(self.contentView.bounds.size.height/2.0 - switchField_.bounds.size.height/2.0);
  
  switchField_.frame = CGRectMake(x, y, switchField_.bounds.size.width, switchField_.bounds.size.height);
  
	[self.contentView bringSubviewToFront:switchField_];
}


@end

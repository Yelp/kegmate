//
//  KBUIFormListSelect.h
//  KegPad
//
//  Created by Gabriel Handford on 10/18/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBUIForm.h"
#import "KBUIFormFieldCell.h"

@interface KBUIFormListSelect : KBUIForm {
  
  UITableViewCell *cell_;
  
  NSArray */*of NSString*/values_;
  NSString *selectedValue_;

}

@property (retain, nonatomic) NSString *selectedValue;

+ (KBUIFormListSelect *)formWithTitle:(NSString *)title values:(NSArray */*of NSString*/)values selectedValue:(NSString *)selectedValue 
                               target:(id)target action:(SEL)action context:(id)context;

@end
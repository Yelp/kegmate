//
//  KBUIFormListSelect.m
//  KegPad
//
//  Created by Gabriel Handford on 10/18/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import "KBUIFormListSelect.h"

@interface KBUIFormListSelect ()
@property (retain, nonatomic) NSArray */*of NSString*/values;
@end


@implementation KBUIFormListSelect

@synthesize values=values_, selectedValue=selectedValue_;

- (id)initWithTitle:(NSString *)title text:(NSString *)text target:(id)target action:(SEL)action context:(id)context showDisclosure:(BOOL)showDisclosure {
  if ((self = [super initWithTitle:title text:text target:target action:action context:context showDisclosure:showDisclosure selectedAction:NULL])) {
    cell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
  }
  return self;
}

- (void)dealloc {
  [cell_ release];
  [super dealloc];
}

+ (KBUIFormListSelect *)formListSelectWithTitle:(NSString *)title values:(NSArray */*of NSString*/)values selectedValue:(NSString *)selectedValue 
                               target:(id)target action:(SEL)action context:(id)context {
  KBUIFormListSelect *form = [[KBUIFormListSelect alloc] initWithTitle:title text:selectedValue target:target action:action context:context showDisclosure:YES];
  form.selectedValue = selectedValue;
  form.values = values;
  return [form autorelease]
  ;
}

- (void)setSelectedValue:(NSString *)selectedValue {
  [selectedValue retain];
  [selectedValue_ release];
  selectedValue_ = selectedValue;
  cell_.detailTextLabel.text = selectedValue_;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  cell_.selectionStyle = (self.selectEnabled ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone);
  cell_.textLabel.text = self.title;
  cell_.detailTextLabel.text = self.selectedValue;
  cell_.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  return cell_;
}

@end
//
//  KBSimulatorViewController.m
//  KegPad
//
//  Created by Gabe on 9/26/10.
//  Copyright 2010 rel.me. All rights reserved.
//

#import "KBSimulatorViewController.h"

#import "KBApplication.h"

@implementation KBSimulatorViewController

- (id)init {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    kegProcessorSimulator_ = [[KBKegProcessorSimulator alloc] initWithKegProcessor:[KBApplication kegProcessor]];
    [self addAction:[KBUIForm actionWithTitle:@"Simulate temperature and pour" text:@"" target:kegProcessorSimulator_ action:@selector(temperatureAndPour) showDisclosure:NO]];
    [self addAction:[KBUIForm actionWithTitle:@"Simulate login" text:@"" target:kegProcessorSimulator_ action:@selector(login) showDisclosure:NO]];
    [self addAction:[KBUIForm actionWithTitle:@"Simulate unknown tag" text:@"" target:kegProcessorSimulator_ action:@selector(unknownTag) showDisclosure:NO]];
  }
  return self;
}

- (void)dealloc {
  [kegProcessorSimulator_ release];
  [super dealloc];
}

@end

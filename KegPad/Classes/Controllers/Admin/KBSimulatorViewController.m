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
  if ((self = [super init])) {
    kegProcessorSimulator_ = [[KBKegProcessorSimulator alloc] initWithKegProcessor:[KBApplication kegProcessor]];
    [self addAction:[KBUIAction actionWithName:@"Simulate temperature and pour" info:@"" target:self action:@selector(_simulateTemperatureAndPour) showDisclosure:NO]];
    [self addAction:[KBUIAction actionWithName:@"Simulate login" info:@"" target:self action:@selector(_simulateLogin) showDisclosure:NO]];
  }
  return self;
}

- (void)dealloc {
  [kegProcessorSimulator_ release];
  [super dealloc];
}

- (void)_simulateTemperatureAndPour {
  [kegProcessorSimulator_ temperatureAndPour];
}

- (void)_simulateLogin {
  [kegProcessorSimulator_ login];
}

@end

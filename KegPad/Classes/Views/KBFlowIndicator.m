//
//  KBFlowIndicator.m
//
//  Created by John Boiles on 10/13/10.
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

#import "KBFlowIndicator.h"
#import "KBKegProcessing.h"
#import "KBNotifications.h"
#import "KBTypes.h"

@implementation KBFlowIndicator

@synthesize needleView=needleView_, fillView=fillView_, volumeLabel=volumeLabel_, flowLabel=flowLabel_;

- (void)awakeFromNib {
  _minimumFlowRate = 0;
  _maximumFlowRate = 3;
  _minimumAngle = -0.41 * M_PI;
  _maximumAngle = 0.41 * M_PI;
  _flowRate = 0;
  
  _minimumVolume = 0;
  _maximumVolume = 16;
  _minimumTopY = 306;
  _maximumTopY = 210;
  _volume = 0;
  
  [self setFlowRate:0 animated:NO];
  [self setVolume:0 animated:NO];
  //[self simulateValues];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onKegDidUpdatePourNotification:) name:KBKegDidUpdatePourNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_onKegDidEndPourNotification:) name:KBKegDidEndPourNotification object:nil];
}

- (void)setRotationRadians:(CGFloat)radians animated:(BOOL)animated {
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, radians);
    needleView_.transform =  CGAffineTransformTranslate(transform, 0, -71);
    [UIView commitAnimations];
  } else {
    CGAffineTransform transform = CGAffineTransformRotate(CGAffineTransformIdentity, radians);
    needleView_.transform =  CGAffineTransformTranslate(transform, 0, -71);
    [needleView_ setNeedsDisplay];
  }
}

- (void)setFlowRate:(double)flowRate animated:(BOOL)animated {
  [flowLabel_ setText:[NSString stringWithFormat:@"%0.1f", flowRate]];
  if (flowRate > _maximumFlowRate) flowRate = _maximumFlowRate;
  if (flowRate < _minimumFlowRate) flowRate = _minimumFlowRate;
  _flowRate = flowRate;
  double fraction = (flowRate - _minimumFlowRate) / (_maximumFlowRate - _minimumFlowRate);
  double angle = fraction * (_maximumAngle - _minimumAngle) + _minimumAngle;
  [[self gh_proxyOnMainThread] setRotationRadians:angle animated:animated];
}

- (void)setTopY:(CGFloat)topY animated:(BOOL)animated {
  if (animated) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationBeginsFromCurrentState:YES];
    fillView_.frame = CGRectMake(fillView_.frame.origin.x, topY, fillView_.frame.size.width, fillView_.frame.size.height);
    [UIView commitAnimations];
  } else {
    fillView_.frame = CGRectMake(fillView_.frame.origin.x, topY, fillView_.frame.size.width, fillView_.frame.size.height);
    [fillView_ setNeedsDisplay];
  }
}

- (void)setVolume:(double)volume animated:(BOOL)animated {
  [volumeLabel_ setText:[NSString stringWithFormat:@"%0.1f", volume]];
  if (volume > _maximumVolume) volume = _maximumVolume;
  if (volume < _minimumVolume) volume = _minimumVolume;
  _volume = volume;
  double fraction = (volume - _minimumVolume) / (_maximumVolume - _minimumVolume);
  CGFloat topY = fraction * (_maximumTopY - _minimumTopY) + _minimumTopY;
  [[self gh_proxyOnMainThread] setTopY:topY animated:animated];
}

- (void)simulateValues {
  _simulationTimer = [[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setSimulatedValue) userInfo:nil repeats:YES] retain];
  _simulatedValueIncreasing = YES;
}

- (void)setSimulatedValue {
  double interval = (_maximumFlowRate - _minimumFlowRate) / 20;
  double interval2 = (_maximumVolume - _minimumVolume) / 20;
  if (_simulatedValueIncreasing) {
    _flowRate += interval;
    _volume += interval2;
    if (_flowRate > _maximumFlowRate) {
      _simulatedValueIncreasing = NO;
    }
  } else {
    _flowRate -= interval;
    _volume -= interval2;
    if (_flowRate < _minimumFlowRate) {
      _simulatedValueIncreasing = YES;
    }
  }
  [self setVolume:_volume animated:YES];
  [self setFlowRate:_flowRate animated:YES];
}

- (void)_onKegDidUpdatePourNotification:(NSNotification *)notification {
  KBKegProcessing *kegProcessing = (KBKegProcessing *)[notification object];
  [self setVolume:kegProcessing.pourVolume * kLitersToOunces animated:YES];
  [self setFlowRate:kegProcessing.flowRate * kLitersToOunces animated:YES];
}

- (void)_onKegDidEndPourNotification:(NSNotification *)notification {
  [self setFlowRate:0 animated:YES];
  [self setVolume:0 animated:YES];
}

@end

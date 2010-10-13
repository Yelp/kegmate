//
//  KBFlowIndicator.h
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

@interface KBFlowIndicator : UIView {
  UIImageView *needleView_;
  UIImageView *fillView_;
  UILabel *volumeLabel_;
  UILabel *flowLabel_;
  
  double _minimumFlowRate;
  double _maximumFlowRate;
  double _minimumAngle;
  double _maximumAngle;
  double _flowRate;

  double _minimumVolume;
  double _maximumVolume;
  double _minimumTopY;
  double _maximumTopY;
  double _volume;

  NSTimer *_simulationTimer;
  BOOL _simulatedValueIncreasing;
}

@property (nonatomic, retain) IBOutlet UIImageView *needleView;
@property (nonatomic, retain) IBOutlet UIImageView *fillView;
@property (nonatomic, retain) IBOutlet UILabel *volumeLabel;
@property (nonatomic, retain) IBOutlet UILabel *flowLabel;

- (void)setFlowRate:(double)flowRate animated:(BOOL)animated;

- (void)setVolume:(double)volume animated:(BOOL)animated;

@end

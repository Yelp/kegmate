//
//  KBKegTimeViewController.h
//  KegPad
//
//  Created by Gabriel Handford on 7/28/11.
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

#import "FFReaderView.h"
#import "FFAVCaptureClient.h"
#import "FFAVCaptureSessionReader.h"
#import "KBKegTimeHost.h"

@interface KBKegTimeViewController : UIViewController {
  FFAVCaptureClient *videoServer_;
  FFReaderView *videoView_;  
}

- (void)close;

- (void)connectToService:(NSNetService *)service;

- (void)connectToHost:(KBKegTimeHost *)host;

- (void)setReader:(id<FFReader>)reader;

- (void)setSecondaryReader:(id<FFReader>)secondaryReader;

@end

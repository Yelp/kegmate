//
//  KBRKThermoLog.m
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 Yelp. All rights reserved.
//

#import "KBRKThermoLog.h"
#import "KBApplication.h"

@implementation KBRKThermoLog

+ (float)min {
  return 4.0;
}

+ (float)max {
  return 21.0;
}

- (RKRequest *)postToAPIWithDelegate:(id)delegate {
  NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.temperatureC, @"temp_c",
                          [KBApplication apiKey], @"api_key",
                          nil];
  return [[RKClient sharedClient] post:[NSString stringWithFormat:@"/thermo-sensors/%@/", self.sensorId] params:params delegate:delegate];
}

- (NSString *)thermometerDescription {
  float temperature = [self.temperatureC floatValue];  
  if (temperature < 10) return @"frosty!";
  else if (temperature < 16) return @"chilly!";
  return @"warm";
}

- (NSString *)temperatureDescription {
  return [NSString stringWithFormat:@"%0.1f°C", [[self temperatureC] doubleValue]];
}

- (NSString *)statusDescription {
  float temperature = [self.temperatureC floatValue];
  if (temperature < 10) return @"COLD CHILLIN'";
  else if (temperature < 16) return @"CHILLIN'";
  return @"WARM";
}

@end
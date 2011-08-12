//
//  FFStreamUtils.h
//  PBR
//
//  Created by Gabriel Handford on 11/18/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFStreamUtils : NSObject {

}

+ (NSData *)dataForIPAddress:(NSString *)address;

+ (BOOL)containsCurrentAddress:(NSSet *)addresses;

+ (NSString *)addressFromData:(NSData *)data;

+ (NSArray *)currentAddresses;

+ (NSSet *)addressStringsFromNetService:(NSNetService *)netService;

@end

//
//  PBRStreamUtils.h
//  PBR
//
//  Created by Gabriel Handford on 11/18/10.
//  Copyright 2010 Yelp. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PBRStreamUtils : NSObject {

}

+ (NSData *)dataForIPAddress:(NSString *)address;

+ (BOOL)containsCurrentAddress:(NSSet *)addresses;

+ (NSString *)addressFromData:(NSData *)data;

+ (NSArray *)currentAddresses;

+ (NSString *)ipv4Address;

+ (NSSet *)addressStringsFromNetService:(NSNetService *)netService;

@end

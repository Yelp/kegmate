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

+ (NSData *)addressForHost:(NSString *)host port:(int)port;

+ (BOOL)containsCurrentAddress:(NSSet *)addresses;

+ (NSSet *)addressStringsFromNetService:(NSNetService *)netService;

@end

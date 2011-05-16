//
//  KBRKKeg.h
//  KegPad
//
//  Created by John Boiles on 5/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <RestKit/RestKit.h>

typedef enum {
  KBKegStatusUnknown,
  KBKegStatusOffline,
  KBKegStatusOnline,
} KBKegStatus;

@interface KBRKKeg : RKObject {
  NSString *_identifier;
  NSNumber *_statusNumber;
  NSNumber *_volumeRemainingNumber;
  NSDate *_startedDate;
  NSDate *_finishedDate;
  NSString *_descriptionText;
  NSString *_typeId;
  NSNumber *_sizeIdNumber;
  NSNumber *_percentFullNumber;
}

@property (retain, nonatomic) NSString *identifier;
@property (retain, nonatomic) NSNumber *statusNumber;
@property (retain, nonatomic) NSNumber *volumeRemainingNumber;
@property (retain, nonatomic) NSDate *startedDate;
@property (retain, nonatomic) NSDate *finishedDate;
@property (retain, nonatomic) NSString *descriptionText;
@property (retain, nonatomic) NSString *typeId;
@property (retain, nonatomic) NSNumber *sizeIdNumber;
@property (retain, nonatomic) NSNumber *percentFullNumber;

@end

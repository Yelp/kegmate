//
//  PBRConnection.h
//  PBR
//
//  Created by Gabriel Handford on 11/19/10.
//  Copyright 2010 Yelp. All rights reserved.
//

@class PBRConnection;

@protocol PBRConnectionDelegate <NSObject>
- (void)connection:(PBRConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length;
- (void)connectionDidClose:(PBRConnection *)connection;
@end

@interface PBRConnection : NSObject <NSStreamDelegate> {
  
  NSString *_serviceName;
  NSOutputStream *_output;
  NSInputStream *_input;
  
  uint8_t *_readBuffer;
  NSUInteger _readBufferSize;
  
  id<PBRConnectionDelegate> _delegate;
  
  // Messages
  uint32_t _headerCommand;
  uint8_t *_headerBuffer;
  NSData *_message;
  NSInteger _messageIndex;
}

@property (assign, nonatomic) id<PBRConnectionDelegate> delegate;

@property (readonly, retain, nonatomic) NSString *serviceName;
@property (retain, nonatomic) NSOutputStream *output;
@property (retain, nonatomic) NSInputStream *input;


- (BOOL)openWithService:(NSNetService *)service;

- (BOOL)openWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;

- (BOOL)openWithName:(NSString *)name ipAddress:(NSString *)ipAddress port:(SInt32)port;

- (NSInteger)writeBytes:(uint8_t *)bytes length:(NSUInteger)length;

- (BOOL)writeMessage:(NSData *)message;

- (void)close;

@end

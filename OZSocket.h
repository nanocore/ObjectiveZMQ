//
//  OZSocket.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OZMessage;

@interface OZSocket : NSObject

@property (nonatomic, assign, readonly) void *zmqSocket;
@property (nonatomic, strong, readonly) dispatch_queue_t socketQueue;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (id)initWithType:(int)socketType;

- (NSURL *)bindZ:(NSString *)endpoint;
- (void)unbindZ:(NSString *)endpoint;

- (NSURL *)connect:(NSString *)endpoint;
- (void)disconnect:(NSString *)endpoint;

- (void)receiveWithBlock:(void (^)(OZMessage *))block onQueue:(dispatch_queue_t)queue;
- (void)send:(OZMessage *)message;

@end

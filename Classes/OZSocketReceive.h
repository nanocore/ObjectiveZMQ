//
//  OZSocketReceive.h
//  ObjectiveZMQTests
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OZSocketReceive <NSObject>

- (OZMessage *)receiveSync;

- (void)receiveWithBlock:(void (^)(OZMessage *))block;
- (void)receiveWithBlock:(void (^)(OZMessage *))block onQueue:(dispatch_queue_t)queue;

@end

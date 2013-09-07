//
//  NSData+ZMQMessage.h
//  ObjectiveZMQTests
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "zmq.h"

@interface NSData (ZMQMessage)

+ (id)dataWithZmqMessage:(zmq_msg_t *)message;

- (id)initWithZmqMessage:(zmq_msg_t *)message;

@end

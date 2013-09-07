//
//  NSData+ZMQMessage.m
//  ObjectiveZMQTests
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import "NSData+ZMQMessage.h"

@implementation NSData (ZMQMessage)

+ (id)dataWithZmqMessage:(zmq_msg_t *)message
{
	NSData *result = [[self alloc] initWithZmqMessage:message];
	return result;
}

- (id)initWithZmqMessage:(zmq_msg_t*)message
{
	if (!message) {
		return nil;
	}
	size_t messageLength = zmq_msg_size(message);
	if (!messageLength) {
		// empty but valid message means emtpy but valid NSData
		return [NSData new];
	}
	void *messageBytes = zmq_msg_data(message);
	if (!messageBytes) {
		return nil;
	}
	NSData *result = [NSData dataWithBytes:messageBytes length:messageLength];
	return result;
}

@end

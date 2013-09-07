//
//  OZSocket+Private.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocket+Private.h"

#import "OZMessage.h"

#import "NSData+ZMQMessage.h"

#import "zmq.h"

@implementation OZSocket (Private)

- (OZMessage *)receive__ALREADY_ON_SOCKET_QUEUE__
{
	int more;
	OZMessage *result = nil;
	do {
		int status;
		zmq_msg_t part;
		status = zmq_msg_init(&part);
		if (status < 0) {
			return nil;
		}

		status = zmq_msg_recv(&part, self.zmqSocket, 0);
		if (status < 0) {
			zmq_msg_close(&part);
			return nil;
		}

		NSData *partData = [NSData dataWithZmqMessage:&part];
		if (!partData) {
			zmq_msg_close(&part);
			return nil;
		}

		if (!result) {
			result = [OZMessage new];
		}
		[result appendPart:partData];

		more = zmq_msg_more(&part);
		zmq_msg_close(&part);
	} while (more);
	return result;
}


- (void)send__ALREADY_ON_SOCKET_QUEUE__:(OZMessage *)message
{
	assert(message);
	for (NSUInteger part = 0; part < message.count; ++part) {
		BOOL more = (part != (message.count - 1));
		NSData *data = [message dataAtIndex:part];

		zmq_send(self.zmqSocket, data.bytes, data.length, more ? ZMQ_SNDMORE : 0);
	}
}

@end

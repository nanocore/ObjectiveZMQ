//
//  OZSocketSub.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocketSub.h"

#import "OZSocket+Subclass.h"
#import "OZSocket+Private.h"

#import "OZSocket+Receive.h"
#import "OZSocket+Send.h"

#import "OZContext.h"

#import "zmq.h"

@implementation OZSocketSub

- (id)init
{
	self = [super initWithType:ZMQ_SUB context:[OZContext defaultContext]];
	if (!self) {
		return nil;
	}

	[self subscribe:[NSData data]];

	return self;
}

- (void)subscribe:(NSData *)prefix
{
//	assert(prefix);
	dispatch_sync(self.socketQueue, ^{
		zmq_setsockopt(self.zmqSocket, ZMQ_SUBSCRIBE, prefix.bytes, prefix.length);
	});
}

- (void)poll:(void (^)(OZMessage *request))handler
{
	OZSocketSub *ownRef = self; // strong reference to self
	assert(handler);
	dispatch_async(self.socketQueue, ^{
		zmq_pollitem_t socketPollItem;
		socketPollItem.socket = ownRef.zmqSocket;
		socketPollItem.events = ZMQ_POLLIN;
		int pollResult = zmq_poll(&socketPollItem, 1, 500 /*ms*/);
		if (pollResult == 1) {
			// a message is ready, read it!
			OZMessage *request = [ownRef receive__ALREADY_ON_SOCKET_QUEUE__];
			if (request) {
				handler(request);
			}
		}
		[ownRef poll:handler];
	});
}

@end

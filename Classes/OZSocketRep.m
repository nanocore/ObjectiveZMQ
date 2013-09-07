//
//  OZSocketRep.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocketRep.h"

#import "OZSocket+Subclass.h"
#import "OZSocket+Private.h"

#import "OZSocket+Receive.h"
#import "OZSocket+Send.h"

#import "OZContext.h"

#import "zmq.h"

@implementation OZSocketRep

- (id)init
{
	self = [super initWithType:ZMQ_REP context:[OZContext defaultContext]];
	if (!self) {
		return nil;
	}

	return self;
}

- (void)poll:(OZMessage *(^)(OZMessage *request))handler
{
	OZSocketRep *ownRef = self; // strong reference to self
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
				OZMessage *reply = handler(request);
				[ownRef send__ALREADY_ON_SOCKET_QUEUE__:reply];
			}
		}
		[ownRef poll:handler];
	});
}

@end

//
//  OZSocketReq.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocketReq.h"

#import "OZSocket+Subclass.h"
#import "OZSocket+Private.h"

#import "OZSocket+Receive.h"
#import "OZSocket+Send.h"

#import "OZContext.h"

#import "zmq.h"

@implementation OZSocketReq

- (id)init
{
	self = [super initWithType:ZMQ_REQ context:[OZContext defaultContext]];
	if (!self) {
		return nil;
	}

	return self;
}

- (void)request:(OZMessage*)message handler:(void (^)(OZMessage *response))callback
{
	OZSocketReq *ownRef = self; // strong reference to self
	assert(message);
	assert(callback);
	dispatch_async(ownRef.socketQueue, ^{
		[ownRef send__ALREADY_ON_SOCKET_QUEUE__:message];
		OZMessage *response = [ownRef receive__ALREADY_ON_SOCKET_QUEUE__];
		if (response) {
			callback(response);
		}
	});
}

@end

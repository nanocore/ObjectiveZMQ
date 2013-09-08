//
//  OZSocket+Receive.m
//  ObjectiveZMQTests
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import "OZSocket+Receive.h"

#import "OZSocket+Private.h"

@implementation OZSocket (Receive)

- (OZMessage *)receiveSync
{
	__block OZMessage *result = nil;
	dispatch_sync(self.socketQueue, ^{
		result = [self receive__ALREADY_ON_SOCKET_QUEUE__];
	});
	return result;
}

- (void)receiveWithBlock:(void (^)(OZMessage *))block
{
	assert(block);
	dispatch_async(self.socketQueue, ^{
		OZMessage *result = [self receive__ALREADY_ON_SOCKET_QUEUE__];
		if (result) {
			block(result);
		}
	});
}

- (void)receiveWithBlock:(void (^)(OZMessage *))block onQueue:(dispatch_queue_t)queue
{
	assert(block);
	assert(queue);
	dispatch_async(self.socketQueue, ^{
		OZMessage *result = [self receive__ALREADY_ON_SOCKET_QUEUE__];
		if (result) {
			dispatch_async(queue, ^{block(result);});
		}
	});
}

@end

//
//  OZSocket.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocket.h"

#import "OZContext.h"
#import "OZMessage.h"

#import "OZSocket+Private.h"

#import "zmq.h"

@interface OZSocket ()

@property (nonatomic, assign) void *zmqSocket;
@property (nonatomic, strong) dispatch_queue_t socketQueue;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong) NSMutableSet *boundEndpoints;
@property (nonatomic, strong) NSMutableSet *connectedEndpoints;
#endif

@end

@implementation OZSocket

- (id)initWithType:(int)socketType
{
	self = [super init];
	if (!self) {
		return nil;
	}

	self.boundEndpoints = [NSMutableSet set];
	self.connectedEndpoints = [NSMutableSet set];

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[center addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif

	self.socketQueue = dispatch_queue_create("OZSocket", 0);
	dispatch_sync(self.socketQueue, ^{
		self->_zmqSocket = zmq_socket([OZContext sharedZmqContext], socketType);
	});

	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	dispatch_sync(self.socketQueue, ^{
		zmq_close(self.zmqSocket);
		self.zmqSocket = NULL;
	});
}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
- (void)didEnterBackground
{
	// close all endpoints
	dispatch_sync(self.socketQueue, ^{
		for (NSString *endpoint in self.boundEndpoints) {
			zmq_unbind(self.zmqSocket, [endpoint UTF8String]);
		}
		for (NSString *endpoint in self.connectedEndpoints) {
			zmq_disconnect(self.zmqSocket, [endpoint UTF8String]);
		}
	});
}

- (void)willEnterForeground
{
	// reopen all endpoints
	dispatch_async(self.socketQueue, ^{
		for (NSString *endpoint in self.boundEndpoints) {
			zmq_bind(self.zmqSocket, [endpoint UTF8String]);
		}
		for (NSString *endpoint in self.connectedEndpoints) {
			zmq_connect(self.zmqSocket, [endpoint UTF8String]);
		}
	});
}
#endif

- (NSURL *)bindZ:(NSString *)endpoint
{
	assert(endpoint.length);
	__block NSURL *result = nil;
	dispatch_sync(self.socketQueue, ^{
		int bindResult = zmq_bind(self.zmqSocket, [endpoint UTF8String]);
		if (bindResult == -1) {
			return;
		}

		char endpointBuffer[4096];
		size_t endpointLength = sizeof(endpointBuffer);
		zmq_getsockopt(self.zmqSocket, ZMQ_LAST_ENDPOINT, endpointBuffer, &endpointLength);

		NSString *addressString = [NSString stringWithUTF8String:endpointBuffer];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		[self.boundEndpoints addObject:addressString];
#endif
		result = [NSURL URLWithString:addressString];
	});
	return result;
}
- (void)unbindZ:(NSString *)endpoint
{
	assert(endpoint.length);
	dispatch_sync(self.socketQueue, ^{
		zmq_unbind(self.zmqSocket, [endpoint UTF8String]);
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		[self.boundEndpoints removeObject:endpoint];
#endif
	});
}

- (NSURL *)connect:(NSString *)endpoint
{
	assert(endpoint.length);
	__block NSURL *result = nil;
	dispatch_sync(self.socketQueue, ^{
		int connectResult = zmq_connect(self.zmqSocket, [endpoint UTF8String]);
		if (connectResult == -1) {
			return;
		}

		char endpointBuffer[4096];
		size_t endpointLength = sizeof(endpointBuffer);
		zmq_getsockopt(self.zmqSocket, ZMQ_LAST_ENDPOINT, endpointBuffer, &endpointLength);

		NSString *addressString = [NSString stringWithUTF8String:endpointBuffer];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		[self.connectedEndpoints addObject:addressString];
#endif
		result = [NSURL URLWithString:addressString];
	});
	return result;
}
- (void)disconnect:(NSString *)endpoint
{
	assert(endpoint.length);
	dispatch_sync(self.socketQueue, ^{
		zmq_disconnect(self.zmqSocket, [endpoint UTF8String]);
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		[self.connectedEndpoints removeObject:endpoint];
#endif
	});
}


#pragma mark message handling

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

- (void)send:(OZMessage *)message
{
	dispatch_async(self.socketQueue, ^{
		[self send__ALREADY_ON_SOCKET_QUEUE__:message];
	});
}

@end

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
#import "OZSocket+Subclass.h"

#import "zmq.h"

@interface OZSocket ()

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@property (nonatomic, strong) NSMutableSet *boundEndpoints;
@property (nonatomic, strong) NSMutableSet *connectedEndpoints;
#endif

@end

@implementation OZSocket

@synthesize zmqSocket; // OZSocket+Subclass
@synthesize socketQueue; // OZSocket+Subclass

- (id)init
{
	[self doesNotRecognizeSelector:_cmd];
	// only instantiate subclasses of OZSocket with initWithType:inContext:
	return nil;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self close];
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

- (NSURL *)bind:(NSString *)endpoint
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
- (void)unbind:(NSString *)endpoint
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

- (void)close
{
	[self closeSocket];
}

@end

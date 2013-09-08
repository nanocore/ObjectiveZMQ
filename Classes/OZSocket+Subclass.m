//
//  OZSocket+Subclass.m
//  ObjectiveZMQTests
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import "OZSocket+Subclass.h"

#import "OZContext.h"

#import "zmq.h"

@implementation OZSocket (Subclass)

- (id)initWithType:(int)socketType context:(OZContext *)context
{
	self = [super init];
	if (!self) {
		return nil;
	}

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	self.boundEndpoints = [NSMutableSet set];
	self.connectedEndpoints = [NSMutableSet set];

	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(didEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
	[center addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif

	self.socketQueue = dispatch_queue_create("OZSocket", 0);
	dispatch_sync(self.socketQueue, ^{
		self.zmqSocket = zmq_socket([context zmqContext], socketType);
	});

	return self;
}

- (void)closeSocket
{
	dispatch_sync(self.socketQueue, ^{
		zmq_close(self.zmqSocket);
		self.zmqSocket = nil;
	});
}

@end

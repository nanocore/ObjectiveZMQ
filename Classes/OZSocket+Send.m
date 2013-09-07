//
//  OZSocket+Send.m
//  ObjectiveZMQ.test
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import "OZSocket+Send.h"

#import "OZSocket+Private.h"

@implementation OZSocket (Send)

- (void)send:(OZMessage *)message
{
	dispatch_async(self.socketQueue, ^{
		[self send__ALREADY_ON_SOCKET_QUEUE__:message];
	});
}

@end

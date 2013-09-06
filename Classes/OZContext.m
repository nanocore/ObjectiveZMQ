//
//  OZContext.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZContext.h"

#import "zmq.h"

@implementation OZContext

+ (void *)sharedZmqContext
{
	static void *result = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result = zmq_ctx_new();
	});
	return result;
}

@end

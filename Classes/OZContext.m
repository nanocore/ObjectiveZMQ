//
//  OZContext.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZContext.h"

#import "zmq.h"

@interface OZContext ()

@property (nonatomic, assign) void *zmqContext;

@end

@implementation OZContext

+ (OZContext *)defaultContext
{
	static OZContext *result = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		result = [OZContext new];
	});
	return result;
}

- (id)init
{
	self = [super init];
	if (!self) {
		return nil;
	}
	self.zmqContext = zmq_ctx_new();
	if (!self.zmqContext) {
		return nil;
	}
	return self;
}

- (void)dealloc
{
	zmq_ctx_destroy(self.zmqContext);
}

@end

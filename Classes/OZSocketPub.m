//
//  OZSocketPub.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocketPub.h"

#import "OZContext.h"

#import "OZSocket+Send.h"

#import "OZSocket+Subclass.h"

#import "zmq.h"

@implementation OZSocketPub

- (id)init
{
	self = [super initWithType:ZMQ_PUB context:[OZContext defaultContext]];
	if (!self) {
		return nil;
	}

	return self;
}

@end

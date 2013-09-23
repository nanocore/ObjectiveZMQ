//
//  OZSocketPush.m
//  unidirectional pipeline push
//
//

#import "OZSocketPush.h"

#import "OZContext.h"

#import "OZSocket+Send.h"

#import "OZSocket+Subclass.h"

#import "zmq.h"

@implementation OZSocketPush

- (id)init
{
	self = [super initWithType:ZMQ_PUSH context:[OZContext defaultContext]];
	if (!self) {
		return nil;
	}

	return self;
}

@end

//
//  OZSocketPull.m
//  Unidirectional pipeline pull
//
//

#import "OZSocketPull.h"

#import "OZSocket+Subclass.h"
#import "OZSocket+Private.h"

#import "OZSocket+Receive.h"

#import "OZContext.h"

#import "zmq.h"

@implementation OZSocketPull

- (id)init
{
	self = [super initWithType:ZMQ_PULL context:[OZContext defaultContext]];
	if (!self) {
		return nil;
	}

	return self;
}

- (void)receiveHandler:(void (^)(OZMessage *response))callback
{
	OZSocketPull *ownRef = self; // strong reference to self
	assert(callback);
	dispatch_async(ownRef.socketQueue, ^{
		OZMessage *response = [ownRef receive__ALREADY_ON_SOCKET_QUEUE__];
		if (response) {
			callback(response);
		}
	});
}

@end

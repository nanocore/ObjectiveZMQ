#import "OZSocket.h"

SpecBegin(OZSocket)

describe(@"OZSocket", ^{
	it(@"should error if you try to init", ^{
		//[[OZSocket alloc] init];
	});

	it(@"should refuse to init the base class", ^{
		expect(^{[OZSocket new];}).to.raiseAny();
	});
});

SpecEnd

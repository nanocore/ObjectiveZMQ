#import "OZSocket.h"

SpecBegin(OZSocket)

describe(@"OZSocket", ^{
	it(@"should refuse to init the base class", ^{
		expect(^{[OZSocket new];}).to.raiseAny();
	});
});

SpecEnd

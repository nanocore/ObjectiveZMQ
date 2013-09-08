#import "OZSocketPub.h"

#import "OZSocketSub.h"
#import "OZMessage.h"

SpecBegin(OZSocketPub)

describe(@"OZSocketPub", ^{
	__block OZSocketPub *pub = nil;
	__block NSString *pubEndpoint = nil;
	beforeAll(^{
		pub = [OZSocketPub new];
		pubEndpoint = [pub bind:@"inproc://spec/OZSocketPub"].absoluteString;
	});

	it(@"should have returned the bound endpoint", ^{
		expect(pubEndpoint).notTo.beNil();
	});

	itShouldBehaveLike(@"OZSocket subclass", ^{
		return @{@"socket":pub};
	});

	it(@"should round-trip simple messages", ^{
		OZSocketSub *sub = [OZSocketSub new];
		[sub subscribe:nil];
		[sub connect:pubEndpoint];

		NSData *outData = [@"sent message" dataUsingEncoding:NSUTF8StringEncoding];
		[pub send:[[OZMessage alloc] initWithData:outData]];

		OZMessage *inMessage = [sub receiveSync];
		NSData *inData = [inMessage dataAtIndex:0];
		expect(outData).to.equal(inData);
	});
});

SpecEnd

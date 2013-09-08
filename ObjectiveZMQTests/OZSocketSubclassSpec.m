#import "OZSocket.h"

#import "OZSocketSend.h"
#import "OZSocketReceive.h"
#import "EXPMatchers+conformToProtocol.h"

SharedExamplesBegin(OZSocketExamples)

sharedExamplesFor(@"OZSocket subclass", ^(NSDictionary *data) {
	it(@"should be a subclass of OZSocket", ^{
		id aSocket = [data objectForKey:@"socket"];
		expect(aSocket).to.beKindOf([OZSocket class]);
		expect(aSocket).notTo.beInstanceOf([OZSocket class]);
	});

	it(@"should be an input and/or output socket", ^{
		id aSocket = [data objectForKey:@"socket"];
		BOOL send = [aSocket conformsToProtocol:@protocol(OZSocketSend)];
		BOOL receive = [aSocket conformsToProtocol:@protocol(OZSocketReceive)];
		BOOL sendOrReceive = send || receive;
		expect(sendOrReceive).to.beTruthy();
	});

	it(@"should refuse invalid URLs to bind and connect", ^{
		OZSocket *socket = [data objectForKey:@"socket"];

		NSURL *result = nil;
		result = [socket bind:@"floogle://ooo"];
		expect(result).to.beNil();
		result = [socket connect:@"floogle://ooo"];
		expect(result).to.beNil();
	});
});

SharedExamplesEnd


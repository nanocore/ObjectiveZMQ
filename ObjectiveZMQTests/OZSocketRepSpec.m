#import "Specta.h"
#import "OZSocketRep.h"

#import "OZSocketReq.h"
#import "OZMessage.h"

SpecBegin(OZSocketRep)

describe(@"OZSocketRep", ^{
	__block OZSocketRep *rep = nil;
	__block NSString *repEndpoint = nil;
	beforeAll(^{
		rep = [OZSocketRep new];
		repEndpoint = [rep bind:@"inproc://spec/OZSocketRep"].absoluteString;

		[rep poll:^OZMessage *(OZMessage *request) {
			NSData *reqInData = [request dataAtIndex:0];

			NSString *responseString = [@"response to: " stringByAppendingString:[[NSString alloc] initWithData:reqInData encoding:NSUTF8StringEncoding]];
			NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
			OZMessage *response = [[OZMessage alloc] initWithData:responseData];
			return response;
		}];
	});

	it(@"should have returned the bound endpoint", ^{
		expect(repEndpoint).notTo.beNil();
	});

	itShouldBehaveLike(@"OZSocket subclass", ^{
		return @{@"socket":rep};
	});

	it(@"should allow basic send-receive pattern", ^{
		OZSocketReq *req = [OZSocketReq new];
		[req connect:repEndpoint];

		NSData *reqOutData = [@"request to send" dataUsingEncoding:NSUTF8StringEncoding];
		OZMessage *requestMessage = [[OZMessage alloc] initWithData:reqOutData];
		[req send:requestMessage];

		[rep receiveWithBlock:^(OZMessage *request) {
			NSData *reqInData = [request dataAtIndex:0];

			NSString *responseString = [@"response to: " stringByAppendingString:[[NSString alloc] initWithData:reqInData encoding:NSUTF8StringEncoding]];
			NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
			OZMessage *response = [[OZMessage alloc] initWithData:responseData];
			[rep send:response];
		}];

		OZMessage *response = [req receiveSync];
		NSData *responseData = [response dataAtIndex:0];
		expect(responseData).to.beTruthy();
		NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

		expect(responseString).to.equal(@"response to: request to send");
	});
});

SpecEnd

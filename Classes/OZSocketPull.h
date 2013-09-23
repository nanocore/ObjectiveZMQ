//
//  OZSocketPull.h
//  Unidirectional pipeline pull
//
//

#import <Foundation/Foundation.h>

#import "OZSocket.h"

#import "OZSocketReceive.h"

@class OZMessage;

@interface OZSocketPull
: OZSocket
< OZSocketReceive >

- (void)receiveHandler:(void (^)(OZMessage *response))callback;

@end

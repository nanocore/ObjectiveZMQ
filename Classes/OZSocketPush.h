//
//  OZSocketPush.h
//  unidirectional pipeline push
//
//

#import <Foundation/Foundation.h>

#import "OZSocket.h"

#import "OZSocketSend.h"

@interface OZSocketPush
: OZSocket
< OZSocketSend >

@end

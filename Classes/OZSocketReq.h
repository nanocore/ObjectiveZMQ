//
//  OZSocketReq.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OZSocket.h"

#import "OZSocketReceive.h"
#import "OZSocketSend.h"

@class OZMessage;

@interface OZSocketReq
: OZSocket
< OZSocketReceive
, OZSocketSend >

- (void)request:(OZMessage*)message handler:(void (^)(OZMessage *response))callback;

@end

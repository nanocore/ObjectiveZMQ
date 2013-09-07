//
//  OZSocketSub.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OZSocket.h"

#import "OZSocketReceive.h"

@interface OZSocketSub
: OZSocket
< OZSocketReceive >

- (void)subscribe:(NSData *)prefix;

- (void)poll:(void (^)(OZMessage *request))handler;

@end

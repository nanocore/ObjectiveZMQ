//
//  OZSocket+Private.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "OZSocket.h"

@interface OZSocket (Private)

- (OZMessage *)receive__ALREADY_ON_SOCKET_QUEUE__;
- (void)send__ALREADY_ON_SOCKET_QUEUE__:(OZMessage *)message;

@end

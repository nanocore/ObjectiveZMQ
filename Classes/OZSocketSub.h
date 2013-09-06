//
//  OZSocketSub.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocket.h"

@interface OZSocketSub : OZSocket

- (void)subscribe:(NSData *)prefix;

- (void)poll:(void (^)(OZMessage *request))handler;

@end

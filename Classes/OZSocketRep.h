//
//  OZSocketRep.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZSocket.h"

@class OZMessage;

@interface OZSocketRep : OZSocket

- (void)poll:(OZMessage *(^)(OZMessage *request))handler;

@end

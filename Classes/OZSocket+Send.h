//
//  OZSocket+Send.h
//  ObjectiveZMQ.test
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import "OZSocket.h"

@interface OZSocket (Send)

- (void)send:(OZMessage *)message;

@end

//
//  OZSocket+Subclass.h
//  ObjectiveZMQTests
//
//  Created by Rowan James on 7/09/13.
//  Copyright (c) 2013 Savage Interactive. All rights reserved.
//

#import "OZSocket.h"

@interface OZSocket ()
@property (nonatomic, assign) void *zmqSocket;
@property (nonatomic, strong) dispatch_queue_t socketQueue;
@end

@interface OZSocket (Subclass)

- (id)initWithType:(int)socketType context:(OZContext *)context;
- (void)closeSocket;

@end

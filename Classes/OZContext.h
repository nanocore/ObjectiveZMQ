//
//  OZContext.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <dispatch/dispatch.h>

@interface OZContext : NSObject

@property (nonatomic, assign, readonly) void *zmqContext;

+ (OZContext *)defaultContext;

@end

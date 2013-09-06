//
//  OZMessage.h
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OZMessage : NSObject

@property (readonly) NSUInteger count;

- (id)initWithJSONObject:(id)object;
- (id)initWithData:(NSData *)data;
- (id)initWithParts:(NSArray *)parts;

- (NSData *)dataAtIndex:(NSUInteger)index;
- (id)JSONObjectAtIndex:(NSUInteger)index;

- (void)appendPart:(NSData *)part;
- (void)appendJSONObject:(id)object;

@end

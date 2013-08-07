//
//  OZMessage.m
//  Procreate
//
//  Created by Rowan James on 30/07/13.
//  Copyright (c) 2013 Savage Interactive Pty Ltd. All rights reserved.
//

#import "OZMessage.h"

@interface OZMessage ()

@property (nonatomic, strong) NSMutableArray *parts;

@end

@implementation OZMessage

- (id)init
{
	self = [super init];
	if (!self) {
		return nil;
	}

	self.parts = [NSMutableArray new];
	
	return self;
}

- (id)initWithJSONObject:(id)object
{
	if (!object) {
		return nil;
	}

	NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
	if (!data) {
		return nil;
	}

	self = [super init];
	if (!self) {
		return nil;
	}

	self.parts = [NSMutableArray arrayWithObject:data];

	return self;
}

- (id)initWithData:(NSData *)data
{
	assert(data);
	self = [super init];
	if (!self) {
		return nil;
	}

	self.parts = [NSMutableArray arrayWithObject:[data copy]];

	return self;
}

- (id)initWithParts:(NSArray *)parts
{
	assert(parts);
	self = [super init];
	if (!self) {
		return nil;
	}

	self.parts = [NSMutableArray new];
	for (NSData *part in parts) {
		[self appendPart:part];
	}

	return self;
}

- (NSUInteger)count
{
	return self.parts.count;
}

- (NSData *)dataAtIndex:(NSUInteger)index
{
	return [self.parts objectAtIndex:index];
}

- (id)JSONObjectAtIndex:(NSUInteger)index
{
	NSData *data = [self dataAtIndex:index];
	id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	return result;
}

- (void)appendPart:(NSData *)part
{
	assert(part);
	[self.parts addObject:[part copy]];
}

- (void)appendJSONObject:(id)object
{
	assert(object);
	NSData *objectData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
	[self appendPart:objectData];
}

@end

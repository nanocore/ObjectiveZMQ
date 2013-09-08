#import "EXPMatchers+conformToProtocol.h"

EXPMatcherImplementationBegin(conformToProtocol, (Protocol *expected)) {
    match(^BOOL{
		return ([actual conformsToProtocol:expected]);
    });

    failureMessageForTo(^NSString *{
        return [NSString stringWithFormat:@"expected: %@ to conform to protocol %@", EXPDescribeObject(actual), NSStringFromProtocol(expected)];
    });

    failureMessageForNotTo(^NSString *{
        return [NSString stringWithFormat:@"expected: %@ not to conform to protocol %@", EXPDescribeObject(actual), NSStringFromProtocol(expected)];
    });
}
EXPMatcherImplementationEnd
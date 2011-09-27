//
//  Signal.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/4/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "Signal.h"


@implementation Signal
@synthesize idSignal, time, category, method, signalPattern, symbol, signalDirection, probability, comment, viewed;

- (BOOL)isUp {
	return [[self.signalDirection stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"UP"];
}

- (BOOL)isNew {
    return [[self.viewed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"1"];
}

- (void) dealloc {
    [viewed release];
	[comment release];
	[idSignal release];
	[time release];
	[probability release];
	[category release];
	[method release];
	[signalPattern release];
	[symbol release];
	[signalDirection release];
	[super	dealloc];
}

@end

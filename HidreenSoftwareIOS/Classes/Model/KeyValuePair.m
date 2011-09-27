//
//  KeyValuePair.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "KeyValuePair.h"


@implementation KeyValuePair
@synthesize key, value;

- (void) dealloc {
	[key release];
	[value release];
	[super dealloc];
}

@end

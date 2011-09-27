//
//  Category.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/4/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "Category.h"


@implementation Category
@synthesize idCategory, name, signals;

- (void)dealloc {
	[name release];
	[signals release];
	[super dealloc];
}

@end

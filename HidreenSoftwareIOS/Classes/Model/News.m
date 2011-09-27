//
//  News.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "News.h"


@implementation News
@synthesize idNews, timeNews, titleNews, content;

- (void)dealloc {
	[content release];
	[idNews release];
	[timeNews release];
	[titleNews release];
	[super dealloc];
}

@end

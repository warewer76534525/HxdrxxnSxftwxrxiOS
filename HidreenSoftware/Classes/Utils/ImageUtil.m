//
//  ImageUtil.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/8/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "ImageUtil.h"


@implementation ImageUtil

- (id)init {
	if (self = [super init]) {
	};
	return (self);
}

- (UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size
{
	// Create a bitmap graphics context
	// This will also set it as the current context
	UIGraphicsBeginImageContext(size);
	
	// Draw the scaled image in the current context
	[image drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// Create a new image from current context
	UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// Pop the current context from the stack
	UIGraphicsEndImageContext();
	
	// Return our new scaled image
	return scaledImage;
}

- (void) dealloc {
	[super dealloc];
}

@end

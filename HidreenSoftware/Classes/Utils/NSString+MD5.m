//
//  NSString+MD5.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/10/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (md5)

- (NSString *) MD5 
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result );
	NSString *md5Str = [NSString stringWithFormat:
				   @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
				   result[0], result[1], result[2], result[3], 
				   result[4], result[5], result[6], result[7],
				   result[8], result[9], result[10], result[11],
				   result[12], result[13], result[14], result[15]
				   ];
	return [md5Str lowercaseString];
}

@end

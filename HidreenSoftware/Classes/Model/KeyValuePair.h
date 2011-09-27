//
//  KeyValuePair.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeyValuePair : NSObject {
	NSString *key;
	NSString *value;
}

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *value;

@end

//
//  Timezone.h
//  HidreenSoftware
//
//  Created by Hidreen International on 9/2/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyValuePair.h"

@interface Timezone : NSObject {

	NSMutableArray *arrKeyValueTimezone;
	
}

- (id) init;
- (NSArray *) getAllTimezones;
- (KeyValuePair *) getTimezoneAtIndex:(NSInteger)index;

@end

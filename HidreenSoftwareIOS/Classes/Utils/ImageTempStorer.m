//
//  ImageTempStorer.m
//  HidreenSoftware
//
//  Created by Jaka Putra on 9/18/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "ImageTempStorer.h"

static ImageTempStorer *instance;
static NSMutableArray *images;

@implementation ImageTempStorer

+ (ImageTempStorer *)GetInstance {
	@synchronized(self) {
		if (!instance) {
			instance = [[ImageTempStorer alloc] init];
            images = [[NSMutableArray alloc] init];
		}
		return instance;
	}
}

- (void) addImage:(NSArray *)imgs {
    //first make sure empty the array
    [self clearImages];
    [images addObjectsFromArray:imgs];
}

- (NSArray *) getImages {
    return images;
}

- (void) clearImages {
    [images removeAllObjects];
}

@end

//
//  Category.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/4/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Category : NSObject {
	int idCategory;
	NSString *name;
	NSArray *signals;
}

@property (nonatomic) int idCategory;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSArray *signals;

@end

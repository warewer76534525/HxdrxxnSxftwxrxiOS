//
//  News.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface News : NSObject {
	NSString *idNews;
	NSString *titleNews;
	NSString *timeNews;
	NSString *content;
}

@property (nonatomic, retain) NSString *idNews;
@property (nonatomic, retain) NSString *titleNews;
@property (nonatomic, retain) NSString *timeNews;
@property (nonatomic, retain) NSString *content;

@end

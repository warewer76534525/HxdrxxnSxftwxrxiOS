//
//  Signal.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/4/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Signal : NSObject {
	NSString *idSignal;
	NSString *time;
	NSString *category;
	NSString *method;
	NSString *signalPattern;
	NSString *symbol;
	NSString *signalDirection;
	NSString *probability;
	NSString *comment;
    NSString *viewed;
}

@property (nonatomic, retain) NSString *idSignal;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSString *signalPattern;
@property (nonatomic, retain) NSString *symbol;
@property (nonatomic, retain) NSString *signalDirection;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *probability;
@property (nonatomic, retain) NSString *viewed;

- (BOOL)isUp;
- (BOOL)isNew;
@end

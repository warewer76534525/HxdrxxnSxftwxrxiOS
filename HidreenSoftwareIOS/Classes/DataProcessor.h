//
//  DataProcessor.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/4/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "News.h"

@interface DataProcessor : NSObject {

}

- (NSArray *) getKeyValueArrayWithJson:(NSString *)json;
- (NSString *)getResponseSessionWithJson:(NSString *)json;
- (NSString *)getResponseEmailWithJson:(NSString *)json;
- (NSString *)getResponseStatusWithJson:(NSString *)json;
- (NSString *)getResponseMessageWithJson:(NSString *)json;
- (NSString *)getResponseRegisteredNameFromJson:(NSString *)json;
- (NSString *)getResponseRegisteredCountryFromJson:(NSString *)json;
- (NSArray *) getCategoryFromString:(NSString *)fullJson;
- (NSArray *) convertToSignalsWithArray:(NSArray *)signalsDicts;
- (NSString *) getMetaSignalFromJson:(NSString *)json;
- (NSArray *) getImagesFromJson:(NSString *)json;
- (NSArray *) getNewsFromJson:(NSString *)json;
- (News *) getNewsWithContentFromJson:(NSString *)json;
	
@end

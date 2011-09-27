//
//  DataProcessor.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/4/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "DataProcessor.h"
#import "JSON.h"
#import "Category.h"
#import "Signal.h"
#import "News.h"
#import "KeyValuePair.h"

@implementation DataProcessor

- (id)init {
    if(self = [super init]) {
    }
    return(self);
}

- (NSString *)getResponseSessionWithJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"session_id"]];
}

- (NSString *)getResponseEmailWithJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
}

- (NSString *)getResponseRegisteredNameFromJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
}

- (NSString *)getResponseRegisteredCountryFromJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"country"]];
}

- (NSString *)getResponseStatusWithJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"status"]];
}

- (NSString *)getResponseMessageWithJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	return [NSString stringWithFormat:@"%@",[dict objectForKey:@"message"]];
}

- (NSArray *) getKeyValueArrayWithJson:(NSString *)json {
	NSMutableArray *result = [[[NSMutableArray alloc]init]autorelease];
	NSDictionary *dict = [json JSONValue];
	NSArray *keys = [dict allKeys];
	for (int i = 0; i < keys.count; i++) {
		KeyValuePair *kvp = [[KeyValuePair alloc] init];
		kvp.key = [keys objectAtIndex:i];
		kvp.value = [dict objectForKey:[keys objectAtIndex:i]];
		[result	 addObject:kvp];
		[kvp release];
	}
	return result;
}

- (NSArray *) getNewsFromJson:(NSString *)json {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSDictionary *dict = [json JSONValue];
	NSArray *news = [dict objectForKey:@"news"];
	for (int i = 0; i < [news count]; i++) {
		NSDictionary *newsDict = [news objectAtIndex:i];
		News *news = [[News alloc] init];
		news.idNews = [newsDict objectForKey:@"id"];
		news.titleNews = [newsDict objectForKey:@"title"];
		news.timeNews = [newsDict objectForKey:@"time"];
		[result addObject:news];
		[news release];
	}
	[result autorelease];
	return result;
}

- (News *) getNewsWithContentFromJson:(NSString *)json {
	News *news = [[News alloc] init];
	NSDictionary *dict = [json JSONValue];
	NSDictionary *dictNews = [dict objectForKey:@"news"];
	news.idNews = [dictNews objectForKey:@"id"];
	news.titleNews = [dictNews objectForKey:@"title"];
	news.timeNews = [dictNews objectForKey:@"time"];
	news.content = [dictNews objectForKey:@"content"];
	[news autorelease];
	return news;
}

- (NSArray *) getCategoryFromString:(NSString *)fullJson {
	NSDictionary *dict = [fullJson JSONValue];
	NSLog(@"typeid: %@", [dict objectForKey:@"typeid"]);
	NSArray *categories = [dict objectForKey:@"groups"];
	NSLog(@"Length: %d", [categories count]);
	NSMutableArray *result = [[NSMutableArray alloc] init];
	for (int i = 0; i < [categories count]; i++) {
		NSDictionary *catDict = [categories objectAtIndex:i];
		NSLog(@"id: %@ name:%@", [catDict objectForKey:@"id"], [catDict objectForKey:@"name"]);
		Category *cat = [[Category alloc] init];
		cat.idCategory = (int)[catDict objectForKey:@"id"];
		cat.name = [catDict objectForKey:@"name"];
		NSArray *arrSignals = [catDict objectForKey:@"signals"];
		cat.signals = [self convertToSignalsWithArray:arrSignals];
		[result addObject:cat];
		[cat release];
	}
	[result autorelease];
	return result;
}

- (NSArray *) convertToSignalsWithArray:(NSArray *)signalsDicts {
	NSMutableArray *result = [[NSMutableArray alloc] init];
	NSLog(@"Signal Length: %d", [signalsDicts count]);
	for (int i = 0; i < [signalsDicts count]; i++) {
		NSDictionary *signalDict = [signalsDicts objectAtIndex:i];
		NSLog(@"Signal id: %@ prob: %@", [signalDict objectForKey:@"id"], [signalDict objectForKey:@"probability"]);
		Signal *signal = [[Signal alloc] init];
		signal.idSignal = [signalDict objectForKey:@"id"];
		signal.time = [signalDict objectForKey:@"time"];
		signal.category = [signalDict objectForKey:@"category"];
		signal.method = [signalDict objectForKey:@"method"];
		signal.signalPattern = [signalDict objectForKey:@"pattern"];
		signal.symbol = [signalDict objectForKey:@"symbol"];
		signal.signalDirection = [signalDict objectForKey:@"direction"];
		signal.probability = [signalDict objectForKey:@"probability"];
		signal.comment = [signalDict objectForKey:@"comment"];
        signal.viewed = [signalDict objectForKey:@"viewed"];
		
		[result addObject:signal];
		[signal release];
	}
	[result autorelease];
	return result;
}

- (NSString *) getMetaSignalFromJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	NSString *result = [dict objectForKey:@"metasignal"];
	return result;
}

- (NSArray *) getImagesFromJson:(NSString *)json {
	NSDictionary *dict = [json JSONValue];
	NSArray *result = [dict objectForKey:@"image"];
	return result;
}

- (void)dealloc {
	[super dealloc];
}

@end

//
//  TokenRegisterer.m
//  HidreenSoftware
//
//  Created by Jogi Silalahi on 9/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "TokenRegisterer.h"
#import "HttpConnection.h"
#import "DataProcessor.h"
#import "DataStorer.h"

#define URL_REGISTER_TOKEN @"http://amygdalahd.com/m/members/token"

@implementation TokenRegisterer

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (void)registerToken:(NSString *)token withEmail:(NSString *)email {
    HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
	NSString *urlDetail = [NSString stringWithFormat:@"%@?email=%@&token=%@", URL_REGISTER_TOKEN, email, token];
	[con startAccessWithUrl:urlDetail];
	[con release];
}

// ====================
// Http Connecion Callbacks
// ====================

#pragma mark NSURLConnection delegate methods
- (NSURLRequest *)connection:(NSURLConnection *)connection 
			 willSendRequest:(NSURLRequest *)request 
			redirectResponse:(NSURLResponse *)redirectResponse {
 	NSLog(@"Connection received data, retain count");
	return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
 	NSLog(@"Received response: %@", response);
	if (receivedData != nil) {
		[receivedData release];
	}
	receivedData = [[NSMutableData alloc] init];
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	NSLog(@"Error receiving response: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 	
	NSString *json=[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	NSLog(@"Response after reg token: %@", json);
	
	DataProcessor *processor = [[DataProcessor alloc] init];
	
	if ([[processor getResponseStatusWithJson:json] isEqualToString:@"1"]) {
        DataStorer *storer = [DataStorer GetInstance];
        [storer setTokenRegistered:YES];
	}
    [json release];
    [processor release];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void) dealloc {
    [receivedData release];
    [super dealloc];
}

@end

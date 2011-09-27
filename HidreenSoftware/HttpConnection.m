
//  HttpConnection.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.


#import "HttpConnection.h"
#import "DataStorer.h"

@implementation HttpConnection

- (id)init
{
    return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id)val
{
    self = [super init];
    if(self) {
        delegate = val;
    }
    return(self);
}

- (void)startAccessWithUrl:(NSString *)urlString {
	NSLog ( @"ACCESS: %@", urlString );
	 	
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
							initWithURL: [NSURL URLWithString:urlString]
							cachePolicy: NSURLRequestReloadIgnoringCacheData
							timeoutInterval: 60
 							 ];
	DataStorer *storer = [DataStorer GetInstance];
	NSString *cookie = [NSString stringWithFormat:@"UA=hisoftIOS; HSSession=%@; HSEmail=%@", [storer getSessionId], [storer getEmail]];
	NSLog(@"cookie: %@", cookie);
	[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	NSURLConnection *connection = [[NSURLConnection alloc]
 								   initWithRequest:request
 								   delegate:delegate
 								   startImmediately:YES];
 	if(!connection) {
 		NSLog(@"connection failed :(");
 	} else {
 		NSLog(@"connection succeeded  :)");
 	}
 	
 	[connection release];
	[request release];  
}

- (void)postDataWithUrl:(NSString *)urlString parameter:(NSString *)param {
	NSLog ( @"POST: %@", urlString );
	NSLog ( @"Param: %@", param );
	
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
									initWithURL: [NSURL URLWithString:urlString]
									cachePolicy: NSURLRequestReloadIgnoringCacheData
									timeoutInterval: 60
									];
	[request setHTTPMethod:@"POST"];
	
	DataStorer *storer = [DataStorer GetInstance];
	NSString *cookie = [NSString stringWithFormat:@"UA=hisoftIOS; HSSession=%@; HSEmail=%@", [storer getSessionId], [storer getEmail]];
	[request addValue:cookie forHTTPHeaderField:@"Cookie"];
	
	[request setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc]
 								   initWithRequest:request
 								   delegate:delegate
 								   startImmediately:YES];
 	if(!connection) {
 		NSLog(@"connection failed :(");
 	} else {
 		NSLog(@"connection succeeded  :)");
 	}
 	
 	[connection release];
	[request release];  
}

- (void)dealloc {
	[super dealloc];
}

@end

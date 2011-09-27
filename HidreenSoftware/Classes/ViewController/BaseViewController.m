    //
//  BaseViewController.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/11/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "BaseViewController.h"
#import "DataProcessor.h"
#import "HomePageView.h"
#import "DataStorer.h"

@implementation BaseViewController
@synthesize receivedData;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) handleSessionExpiredWithMessage: (NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    [alert release];
    [[DataStorer GetInstance] logout];
    HomePageView *view = [[HomePageView alloc] init];
    [self.navigationController pushViewController:view animated:YES];
    [view release];
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
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int responseStatusCode = [httpResponse statusCode];
    
    NSLog(@"Response code: %d", responseStatusCode);
    
	if (receivedData != nil) {
		[receivedData release];
	}
	receivedData = [[NSMutableData alloc] init];
	[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
 	NSLog(@"Received %d bytes of data", [data length]); 
	[receivedData appendData:data];
 	NSLog(@"Received data is now %d bytes", [receivedData length]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	NSLog(@"Error receiving response: %@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Connecting" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 	
	//implement in the subclass
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    NSLog(@"CACHE IGNORED");
    return nil;
}

// ====================
// Memory Management
// ====================

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[receivedData release];
    [super dealloc];
}


@end

//
//  ImageDownloader.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "ImageDownloader.h"
#import "HttpConnection.h"
#import "ImageUtil.h"

@implementation ImageDownloader
@synthesize delegate, downloadedImages, receivedData;

- (id) initWithUrls:(NSArray *)urlArr {
	self = [super init];
    if(self) {
        urls = urlArr;
		[urls retain];
		currentDownload = 0;
		downloadedImages = [[NSMutableArray alloc] init];
    }
    return(self);
}

- (id)init
{
    return [self initWithUrls:nil];
}

- (void)downloadImageWithUrl:(NSString *)urlImage {
	HttpConnection *conn = [[HttpConnection alloc] initWithDelegate:self];
	[conn startAccessWithUrl:urlImage];
	[conn release];
}

- (void)startDownload {
	NSLog(@"Downloading first images");
	[self downloadImageWithUrl:[urls objectAtIndex:currentDownload]];
	currentDownload = currentDownload + 1;
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
 	NSLog(@"Received %d bytes of data", [data length]); 
	[receivedData appendData:data];
 	NSLog(@"Received data is now %d bytes", [receivedData length]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	NSLog(@"Error receiving response: %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//	ImageUtil *imageUtil = [[ImageUtil alloc] init];
	UIImage *image = [[UIImage alloc] initWithData:receivedData];
	//UIImage *scaledImage = [imageUtil image:image scaleToSize:CGSizeMake(295, 221)];
	[self.downloadedImages addObject:image];
	[image release];

	if (currentDownload == urls.count) {
		NSLog(@"Done downloading %d images", self.downloadedImages.count);
		[delegate finishedWithImages:self.downloadedImages];
	} else {
		NSLog(@"Downloading next images");
		[self downloadImageWithUrl:[urls objectAtIndex:currentDownload]];
		currentDownload = currentDownload + 1;
	}
    //[imageUtil release];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (void) dealloc {
	[downloadedImages release];
    [urls release];
	[receivedData release];
	[super dealloc];
}

@end

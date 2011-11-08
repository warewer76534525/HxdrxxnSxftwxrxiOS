//
//  NewsDetailView.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "NewsDetailView.h"
#import "HttpConnection.h"
#import "DataProcessor.h"
#import "HomePageView.h"
#import "DataStorer.h"

#define NEWS_DETAIL_URL @"http://amygdalahd.com/m/news/view/"

@implementation NewsDetailView
@synthesize loadingView, lblTitle, lblTime, wvNews, newsId;


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = NO;
	wvNews.delegate = self;
	[self retrieveNewsDetailData];
}

- (void)showLoading {
	loadingView.hidden = NO;
	wvNews.userInteractionEnabled = NO;
}

- (void)stopLoading {
	loadingView.hidden = YES;
	wvNews.userInteractionEnabled = YES;
}

- (void)retrieveNewsDetailData {
	[self showLoading];
	HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
	NSString *urlDetail = [NSString stringWithFormat:@"%@%@", NEWS_DETAIL_URL, self.newsId];
	[con startAccessWithUrl:urlDetail];
	[con release];
}

//================
// WebView Delegate methods
//================

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"Rotating..");
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [wvNews setFrame:CGRectMake(0, 45, 480, 226)];
        [lblTitle setFrame:CGRectMake(10, 2, 460, 21)];
        [loadingView setFrame:CGRectMake((320 - 145), 110, 135, 40)];
    } else {
        [wvNews setFrame:CGRectMake(0, 45, 320, 370)];
        [loadingView setFrame:CGRectMake(90, 185, 135, 40)];
        [lblTitle setFrame:CGRectMake(10, 2, 300, 21)];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	lblTitle.text = news.titleNews;
	lblTime.text = news.timeNews;
    
	[self stopLoading];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	[super connection:connection didFailWithError:error];
	[self stopLoading];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 	
	NSString *json=[[NSString alloc] initWithData:super.receivedData encoding:NSUTF8StringEncoding];
 	NSLog(@"String data: %@", json);
	
	DataProcessor *processor = [[DataProcessor alloc] init];
	
	if ([[processor getResponseStatusWithJson:json] isEqualToString:@"0"]) {
		[super handleSessionExpiredWithMessage:[processor getResponseMessageWithJson:json]];
	} else {
		news = [processor getNewsWithContentFromJson:json];
		[news retain];
		[wvNews loadHTMLString:news.content baseURL:nil];
	}
	
	[json release];
	[processor release];
}

- (void)dealloc {
	[news release];
	[newsId release];
	[lblTime release];
	[lblTitle release];
	[wvNews release];
	[loadingView release];
    [super dealloc];
}

@end

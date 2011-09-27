//
//  NewsListView.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "NewsListView.h"
#import "CustomNewsCell.h"
#import "DataProcessor.h"
#import "News.h"
#import "HttpConnection.h"
#import "NewsDetailView.h"
#import "HomePageView.h"
#import "DataStorer.h"

#define	NEWS_URL @"http://www.hidreensoftware.com/m/news"

@implementation NewsListView
@synthesize tView, loadingView;

- (void)viewDidLoad {
    [super viewDidLoad];
	listNews = [[NSMutableArray alloc] init];
	tView.delegate = self;
	tView.dataSource = self;
	
	[self retrieveNewsData];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.title = @"News";
	self.navigationController.navigationBarHidden = YES;
    [tView deselectRowAtIndexPath:[tView indexPathForSelectedRow] animated:YES];
}

- (void)refreshData {
	[self retrieveNewsData];
}

- (void)showLoading {
	tView.alpha = 0.75;
	tView.userInteractionEnabled = NO;
	loadingView.hidden = NO;
}

- (void)stopLoading {
	tView.alpha = 1.0;
	loadingView.hidden = YES;
	tView.userInteractionEnabled = YES;
}

- (void)retrieveNewsData {
	[self showLoading];
	HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
	[con startAccessWithUrl:NEWS_URL];
	[con release];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return listNews.count;
}

- (News *)newsAtIndexPath:(NSIndexPath *)indexPath {
	return [listNews objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellId = @"CustomNewsCellId";
	CustomNewsCell *cell = (CustomNewsCell *) [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if(cell == nil)
	{
		NSArray *topLevelObect = [[NSBundle mainBundle] loadNibNamed:@"CustomNewsCell" owner:nil options:nil];
		for(id currentObject in topLevelObect)
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (CustomNewsCell *) currentObject;
			}
		}
	}
	
	cell.lblNewsTitle.text = [(News *)[self newsAtIndexPath:indexPath] titleNews];
	cell.lblNewsTime.text = [(News *)[self newsAtIndexPath:indexPath] timeNews];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	News *news = [listNews objectAtIndex:indexPath.row];
	NewsDetailView *view = [[NewsDetailView alloc] init];
	view.title = @"News";
	view.newsId = news.idNews;
	[self.navigationController pushViewController:view animated:YES];
	[view release];
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
		NSArray *news = [processor getNewsFromJson:json];
		[listNews removeAllObjects];
		[listNews addObjectsFromArray:news];
		[tView reloadData];
	}
	
	[json release];
	[processor release];
	[self stopLoading];
	
}

- (void)dealloc {
	[listNews release];
	[tView release];
	[loadingView release];
    [super dealloc];
}

@end

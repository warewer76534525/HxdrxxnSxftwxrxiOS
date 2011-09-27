//
//  ProfileView.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/11/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "ProfileView.h"
#import "DataStorer.h"
#import "HomePageView.h"
#import "HttpConnection.h"
#import "DataProcessor.h"

#define URL_LOGOUT @"http://www.hidreensoftware.com/m/members/logout"

@implementation ProfileView
@synthesize loadingView, btnLogout, tProfile;

- (void)viewDidLoad {
	tProfile.delegate = self;
	tProfile.dataSource = self;
    [super viewDidLoad];
}

- (void)showLoading {
	loadingView.hidden = NO;
	btnLogout.userInteractionEnabled = NO;
}

- (void)stopLoading {
	loadingView.hidden = YES;
	btnLogout.userInteractionEnabled = YES;
}

- (void)btnLogoutClicked {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"You will not be notified until you re-login." delegate:self cancelButtonTitle:@"YES" otherButtonTitles: @"NO", nil];
	[alert show];
	[alert release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	[super connection:connection didFailWithError:error];
	[self stopLoading];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
 	NSString *json = [[NSString alloc] initWithData:super.receivedData encoding:NSUTF8StringEncoding];
	
	DataProcessor *processor = [[DataProcessor alloc] init];
	NSString *status = [processor getResponseStatusWithJson:json];
	NSString *message = [processor getResponseMessageWithJson:json];
	
	if ([status isEqualToString:@"1"]) {
		[[DataStorer GetInstance] logout];
		HomePageView *view = [[HomePageView alloc] init];
		[self.navigationController pushViewController:view animated:YES];
		[view release];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Logout" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}

	[json release];
	[processor release];
	[self stopLoading];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellId = @"ProfileTableViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellId] autorelease];
	}
	DataStorer *storer = [DataStorer GetInstance];
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Name";
			cell.detailTextLabel.text = [storer getName];
			break;
		case 1:
			cell.textLabel.text = @"Email";
			cell.detailTextLabel.text = [storer getEmail];
			break;
		case 2:
			cell.textLabel.text = @"Country";
			cell.detailTextLabel.text = [storer getCountry];
			break;
		default:
			break;
	}
	
	return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSLog(@"Clicked: %d", buttonIndex);
	if (buttonIndex == 0) {
		[self showLoading];
		HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
		[con startAccessWithUrl:URL_LOGOUT];
		[con release];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[tProfile release];
	[btnLogout release];
	[loadingView release];
    [super dealloc];
}


@end

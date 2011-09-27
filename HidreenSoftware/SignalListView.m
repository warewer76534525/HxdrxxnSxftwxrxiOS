//
//  SignalListView.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "SignalListView.h"
#import "CustomSignalCell.h"
#import	"HttpConnection.h"
#import "DataProcessor.h"
#import "Category.h"
#import "Signal.h"
#import "SignalDescriptionview.h"
#import "HomePageView.h"
#import "DataStorer.h"

#define SIGNALS_URL @"http://www.hidreensoftware.com/index.php/m/signals"

@implementation SignalListView
@synthesize tView, loadingView;

- (void)viewDidLoad {
	[super viewDidLoad];
	NSLog(@"Signal View Loaded");
	
	listSignalCategory = [[NSMutableArray alloc] init];
	tView.delegate = self;
	tView.dataSource = self;
	imgUp = [UIImage imageNamed:@"green.png"];
	imgDown = [UIImage imageNamed:@"red.png"];
    imgNew = [UIImage imageNamed:@"alert.png"];
	
	[self retrieveSignalsData];
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.title = @"Signals";
	self.navigationController.navigationBarHidden = YES;
    [tView deselectRowAtIndexPath:[tView indexPathForSelectedRow] animated:YES];
}

- (void)refreshData {
	[self retrieveSignalsData];
}

- (void)retrieveSignalsData {
	[self showLoading];
	HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
	[con startAccessWithUrl:SIGNALS_URL];
	[con release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [listSignalCategory count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[listSignalCategory objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSArray *signals = [(Category *)[listSignalCategory objectAtIndex:section] signals];
	return [signals count];
}

- (Signal *)signalAtIndexPath:(NSIndexPath *)indexPath {
	NSArray *signals = [[listSignalCategory objectAtIndex:indexPath.section] signals];
	return [signals objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellId = @"CustomSignalCellId";
	CustomSignalCell *cell = (CustomSignalCell *) [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if(cell == nil)
	{
		NSArray *topLevelObect = [[NSBundle mainBundle] loadNibNamed:@"CustomSignalCell" owner:nil options:nil];
		for(id currentObject in topLevelObect)
		{
			if ([currentObject isKindOfClass:[UITableViewCell class]]) {
				cell = (CustomSignalCell *) currentObject;
			}
		}
	}
	Signal *signal = [self signalAtIndexPath:indexPath];
	cell.lblSymbol.text = [signal symbol];
	
    if ([signal isNew]) {
        cell.imgNew.alpha = 1;
        cell.imgNew.image = imgNew;
    } else {
        cell.imgNew.alpha = 0;
    }
    
	if ([signal isUp]) {
		cell.imgDirection.image = imgUp;
		cell.lblDirection.text = @"UP";
	} else {
		cell.imgDirection.image = imgDown;
		cell.lblDirection.text = @"DOWN";
	}
	cell.lblProbability.text = [NSString stringWithFormat:@"%@%%", [signal probability]];
        
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Signal *signal = [self signalAtIndexPath:indexPath];
	SignalDescriptionview *view = [[SignalDescriptionview alloc] init];
	view.title = [signal symbol];
	view.signalId = [signal idSignal];
	[self.navigationController pushViewController:view animated:YES];
	[view release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[super connection:connection didFailWithError:error];
	[self stopLoading];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 	
 	NSString *json=[[NSString alloc] initWithData:super.receivedData encoding:NSUTF8StringEncoding];
    DataProcessor *processor = [[DataProcessor alloc] init];

	if ([[processor getResponseStatusWithJson:json] isEqualToString:@"0"]) {
        [super handleSessionExpiredWithMessage:[processor getResponseMessageWithJson:json]];
	} else {
		[listSignalCategory removeAllObjects];
		NSArray *cats = [processor getCategoryFromString:json];
		[listSignalCategory addObjectsFromArray:cats];
		[tView reloadData];
	}
	
	[processor release];
	[json release];
	[self stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
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

- (void)dealloc {
	NSLog(@"dealloc");
	[listSignalCategory release];
	[imgUp release];
	[imgDown release];
	[tView release];
	[loadingView release];
    [super dealloc];
}


@end

//
//  TimeZoneListMenu.m
//  HidreenSoftware
//
//  Created by Hidreen International on 9/1/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "TimeZoneListMenu.h"
#import "Timezone.h"
#import "KeyValuePair.h"

@implementation TimeZoneListMenu
@synthesize tView, delegate;

- (void)viewDidLoad {
	
	Timezone *times = [[Timezone alloc] init];
	arrTimeZone = [[times getAllTimezones] retain];
	[times release];
	
	tView.delegate = self;
	tView.dataSource = self;
	
    [super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	NSLog(@"Count: %d", arrTimeZone.count);
	return arrTimeZone.count;
}

- (KeyValuePair *) objectAtIndexPath: (NSIndexPath *)indexPath {
	return [arrTimeZone objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{	
	static NSString *cellId = @"TimezoneTableViewCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	}
	
	KeyValuePair *kvp = [self objectAtIndexPath:indexPath];
	cell.textLabel.text = kvp.value;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	KeyValuePair *kvp = [self objectAtIndexPath:indexPath];
	[delegate onTimezoneSelected:kvp];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[tView release];
	[arrTimeZone release];
    [super dealloc];
}

@end

//
//  RegisterScreen.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "RegisterScreen.h"
#import "CustomEditField.h"
#import "HttpConnection.h"
#import "DataProcessor.h"
#import "KeyValuePair.h"
#import "NSString+MD5.h"
#import "TimeZoneListMenu.h"
#import "Timezone.h"
#import "DataStorer.h"

#define URL_REGISTER @"http://amygdalahd.com/m/members/register"

@implementation RegisterScreen

- (void)retrieveRegisterForm {
	HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
	[con startAccessWithUrl:URL_REGISTER];
	[con release];
}

- (void)showLoading {
	loadingView.hidden = NO;
}

- (void)stopLoading {
	loadingView.hidden = YES;
}

- (void)disableButton {
	btnRegister.alpha = 0.75;
	btnRegister.userInteractionEnabled = NO;
}

- (void)enableButton {
	btnRegister.alpha = 1.0;
	btnRegister.userInteractionEnabled = YES;
}

- (void)postRegisterData {
	isSubmitting = YES;
	BOOL isValid = YES;
	NSMutableString *param = [[NSMutableString alloc] init];
	for (int i=0; i < listFormFields.count; i++) {
		CustomEditField *cef = [listFormFields objectAtIndex:i];
		if ([[[cef getValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""] ||
			[[cef getValue] rangeOfString:@"null"].location != NSNotFound) {
			isValid = NO;
		}
		if ([cef.name rangeOfString:@"password"].location != NSNotFound) {
			NSString *pwd = [NSString stringWithFormat:@"hisoft%@", [cef getValue]];
			[param appendFormat:@"%@=%@&", cef.name, [pwd MD5]];
		} else {
			[param appendFormat:@"%@=%@&", cef.name, [cef getValue]];
		}
	}
	[param appendFormat:@"timezone=%@&", keyTimezone];
	[param appendFormat:@"__submit=register"];
	NSLog(@"param: %@", param);
	
	if (isValid) {
		[self disableButton];
		HttpConnection *conn = [[HttpConnection alloc] initWithDelegate:self];
		[conn postDataWithUrl:URL_REGISTER parameter:param];
		[conn release];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Data" message:@"Please fill all the blank fields." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
		[alert show];
		[alert release];
	}
	
	[param release];
}

- (void)viewDidLoad {
	[self showLoading];
	[self retrieveRegisterForm];
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
	self.title = @"Register";
	self.navigationController.navigationBarHidden = NO;
	isSubmitting = NO;
}

- (void)showTimezoneMenu {
	TimeZoneListMenu *view = [[TimeZoneListMenu alloc] init];
	view.title = @"Select Timezone";
	view.delegate = self;
	[self.navigationController pushViewController:view animated:YES];
	[view release];
}

- (void) initTimeZoneFieldValue {
	Timezone *tz = [[Timezone alloc] init];
	KeyValuePair *kvp = [[tz getTimezoneAtIndex:0] retain];
	
	[timezoneField setText:kvp.value];
	keyTimezone = kvp.key;
	
	[tz release];
	[kvp release];
}

- (NSArray *) buildFieldsWithArray:(NSArray *)fields {
	NSMutableArray *arr = [[[NSMutableArray alloc] init] autorelease];
	UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
	for (int i = 0; i < fields.count; i++) {
		KeyValuePair *kvp = [fields objectAtIndex:i];
		CustomEditField *ef = [[CustomEditField alloc] initWithFrame:CGRectMake(0, i * 60, [UIScreen mainScreen].bounds.size.width, 55) withId:kvp.key andLabel:kvp.value];
		[arr addObject:ef];
		[sv addSubview:ef];
		[ef release];
	}
	//==== add timezone field =========
	timezoneField = [[CustomEditField alloc] initWithFrame:CGRectMake(0, fields.count * 60, ([UIScreen mainScreen].bounds.size.width - 40), 55) withId:@"timezone" andLabel:@"Timezone"];
	//[f setText:@"GMT + 7 Jakarta, Hanoi, Bangkok, Thailand"];
	[timezoneField setUserInteractionEnabled:NO];
	[sv addSubview:timezoneField];
	
	UIButton *btnSelect = [UIButton  buttonWithType:UIButtonTypeDetailDisclosure];
	[btnSelect addTarget:self action:@selector(showTimezoneMenu) forControlEvents:UIControlEventTouchUpInside];
	btnSelect.frame = CGRectMake(270, (fields.count * 60) + 20, 40, 35);
	[sv addSubview:btnSelect];
	[self initTimeZoneFieldValue];
	//=================================
	
	btnRegister = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[btnRegister setTitle:@"Register" forState:UIControlStateNormal];
	btnRegister.frame = CGRectMake(10, ((fields.count + 1) * 60) + 5, 120, 35);
	[btnRegister addTarget:self action:@selector(postRegisterData) forControlEvents:UIControlEventTouchUpInside];
	[sv addSubview:btnRegister];
	
	sv.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, (60 * (fields.count + 2)) + 50 + 225);
	[self.view addSubview:sv];
	[sv release];
	return arr;
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)onPostingSuccessWithMessage:(NSString *)message {
	[self showAlertWithTitle:@"Succees" andMessage:message];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)onPostingFailedWithMessage:(NSString *)message {
	[self showAlertWithTitle:@"Failed" andMessage:message];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	[self stopLoading];
	if (btnRegister) {
		[self enableButton];
	}
	[super connection:connection didFailWithError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
 	NSString *json = [[NSString alloc] initWithData:super.receivedData encoding:NSUTF8StringEncoding];
	NSLog(@"%@", json);
	DataProcessor *processor = [[DataProcessor alloc] init];
	
	if (isSubmitting) {
		NSString *result = [processor getResponseStatusWithJson:json];
		NSLog(@"Result: %@", result);
		if ([@"0" isEqualToString:result]) {
			[self onPostingFailedWithMessage:[processor getResponseMessageWithJson:json]];
		} else {
			[self onPostingSuccessWithMessage:[processor getResponseMessageWithJson:json]];
		}
	} else {
		listFormFields =  [[self buildFieldsWithArray:[processor getKeyValueArrayWithJson:json]] retain];
	}
	
	[self enableButton];
	
	[json release];
	[processor release];
	[self stopLoading];
}

- (void)onTimezoneSelected:(KeyValuePair *)kvpTimeZone {
	[timezoneField setText:kvpTimeZone.value];
	keyTimezone = kvpTimeZone.key;
}

- (void)dealloc {
	[timezoneField release];
	//[keyTimezone release];
	//[btnRegister release];
	[loadingView release];
	[listFormFields release];
    [super dealloc];
}

@end

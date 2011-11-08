//
//  HomePageView.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "HomePageView.h"
#import "SignalListView.h"
#import "HttpConnection.h"
#import "NSString+MD5.h"
#import "DataProcessor.h"
#import "DataStorer.h"
#import "RegisterScreen.h"
#import "UIDevice+Hardware.h"

#define URL_LOGIN @"http://amygdalahd.com/m/members/login"

@implementation HomePageView
@synthesize btnLogin, btnRegister, tbc, txtEmail, txtPassword, loadingView;

- (void)viewDidLoad {
	NSLog(@"HomeView Loaded. System Model: %@", [[UIDevice currentDevice] platformString]);
	
	//self.title = @"Hidreen Software";
	txtEmail.delegate = self;
	txtPassword.delegate = self;
	DataStorer *storer = [DataStorer GetInstance];
	if ([storer isLoggedIn]) {
		NSLog(@"Loged In with session: %@", [storer getSessionId] );
		[self goToHomePage];
	} else {
		NSLog(@"Not Loged In");
		txtEmail.text = [storer getEmail];
	}
	
    [super viewDidLoad];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.navigationBarHidden = YES;
}

-(void) showLoading {
	loadingView.hidden = NO;
	btnLogin.userInteractionEnabled = NO;
	btnLogin.alpha = 0.65;
    btnRegister.userInteractionEnabled = NO;
	btnRegister.alpha = 0.65;
}

-(void) stopLoading {
	loadingView.hidden = YES;
	btnLogin.userInteractionEnabled = YES;
	btnLogin.alpha = 1.0;
    btnRegister.userInteractionEnabled = YES;
	btnRegister.alpha = 1.0;
}

- (void)doLogin {
	[self showLoading];
    DataStorer *storer = [DataStorer GetInstance];
	NSString *pwd = [NSString stringWithFormat:@"hisoft%@", txtPassword.text];
	NSString *params = [NSString stringWithFormat:@"email=%@&password=%@&type=ios&osversion=%@&model=%@&address=%@&__submit=login", txtEmail.text, [pwd MD5], [[UIDevice currentDevice] systemVersion], [[UIDevice currentDevice] platformString], [storer getPushToken]];
	HttpConnection *con = [[HttpConnection alloc] initWithDelegate:self];
	[con postDataWithUrl:URL_LOGIN parameter:params];
	[con release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    //return YES;
}

//- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    NSLog(@"Rotating");
//}

- (void)goToHomePage {
	tbc.navigationItem.hidesBackButton = YES;
	[self.navigationController pushViewController:tbc animated:NO];
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration: 2.0];
//    tbc.view.transform = CGAffineTransformMakeRotation(M_PI/2);
//    [UIView setAnimationDelegate:self];
//    [UIView commitAnimations];
    
}

- (IBAction)goToRegisterPage {
	RegisterScreen *screen = [[RegisterScreen alloc] init];
	[self.navigationController pushViewController:screen animated:YES];
	[screen release];
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
 	[self stopLoading];
	NSLog(@"Error receiving response: %@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Connecting" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection { 	
 	NSString *json=[[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
 	NSLog(@"String data: %@", json);
	
	DataProcessor *processor = [[DataProcessor alloc] init];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hidreen Software" message:[processor getResponseMessageWithJson:json] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
	[alert show];
	[alert release];
	
	NSString *stat = [processor getResponseStatusWithJson:json];
	[stat retain];
	if ([stat isEqualToString:@"1"]) {
		DataStorer *storer = [DataStorer GetInstance];
		[storer setEmailWithEmail:[processor getResponseEmailWithJson:json]];
		[storer setSessionIdWithSession:[processor getResponseSessionWithJson:json]];
		[storer setNameWithName:[processor getResponseRegisteredNameFromJson:json]];
		[storer setCountryWithCountry:[processor getResponseRegisteredCountryFromJson:json]];
		[self goToHomePage];
	}
	
	[self stopLoading];
	
	[json release];
	[stat release];
	[processor release];
	
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
	[btnLogin release];
    [btnRegister release];
	[loadingView release];
	[txtEmail release];
	[txtPassword release];
	[receivedData release];
    [super dealloc];
}


@end

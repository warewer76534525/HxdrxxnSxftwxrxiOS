//
//  HidreenSoftwareAppDelegate.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "HidreenSoftwareAppDelegate.h"
#import "HomePageView.h"
#import "DataStorer.h"
#import "TokenRegisterer.h"

@implementation HidreenSoftwareAppDelegate

@synthesize window, tabBarControlller;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
        
    if(!nav) nav = [[UINavigationController alloc] init];

	HomePageView *view = [[HomePageView alloc] init];
	[nav pushViewController:view animated:NO];
	[window addSubview:nav.view];
	[view release];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)registerForPushService {
    // Let the device know we want to receive push notifications
    NSLog(@"Register for push notification");
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
}

- (void)sendTokenToServer {
    DataStorer *storer = [DataStorer GetInstance];
    TokenRegisterer *tokenreg = [[TokenRegisterer alloc] init];
    [tokenreg registerToken:[storer getPushToken] withEmail:[storer getEmail]];
    [tokenreg release];
}

// ==== Push Notification Service Delegate==
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<> "]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    DataStorer *storer = [DataStorer GetInstance];
    [storer setPushToken:token];
	NSLog(@"My token is: %@", token);
    if ([storer isLoggedIn] && [storer isTokenRegistered] == NO) {
        [self sendTokenToServer];
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Signals" message:@"New signals data. Refresh signals page to view." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

// ===

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self registerForPushService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application 
{   
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self registerForPushService];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end

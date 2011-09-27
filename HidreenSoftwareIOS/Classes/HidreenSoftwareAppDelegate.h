//
//  HidreenSoftwareAppDelegate.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HidreenSoftwareAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UITabBarController *tabBarControlller;
	UINavigationController *nav;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarControlller;

@end


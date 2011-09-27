//
//  BaseViewController.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/11/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController {
	NSMutableData *receivedData;
}

@property (nonatomic, retain) NSMutableData *receivedData;

- (void) handleSessionExpiredWithMessage: (NSString *)message;
@end

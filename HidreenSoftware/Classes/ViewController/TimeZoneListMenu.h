//
//  TimeZoneListMenu.h
//  HidreenSoftware
//
//  Created by Hidreen International on 9/1/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterScreen.h"


@interface TimeZoneListMenu : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tView;
	NSArray *arrTimeZone;
	id<TimezoneSelectDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) id<TimezoneSelectDelegate> delegate;

@end

//
//  ProfileView.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/11/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface ProfileView : BaseViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	UIView *loadingView;
	UIButton *btnLogout;
	UITableView *tProfile;
}
 
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UIButton *btnLogout;
@property (nonatomic, retain) IBOutlet UITableView *tProfile;

- (IBAction) btnLogoutClicked;

@end

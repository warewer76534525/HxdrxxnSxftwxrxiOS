//
//  SignalListView.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SignalListView : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *listSignalCategory;
	IBOutlet UITableView *tView;
	IBOutlet UIView *loadingView;
	UIImage *imgUp;
	UIImage *imgDown;
    UIImage *imgNew;
}

@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;

- (void)retrieveSignalsData;
- (void)showLoading;
- (void)stopLoading;
- (IBAction)refreshData;

@end

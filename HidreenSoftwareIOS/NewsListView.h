//
//  NewsListView.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


@interface NewsListView : BaseViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *tView;
	IBOutlet UIView *loadingView;
	NSMutableArray *listNews;
}

@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;

- (void)retrieveNewsData;
- (IBAction)refreshData;

@end

//
//  NewsDetailView.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"
#import "BaseViewController.h"

@interface NewsDetailView : BaseViewController <UIWebViewDelegate> {
	IBOutlet UIView *loadingView;
	IBOutlet UILabel *lblTitle;
	IBOutlet UILabel *lblTime;
	IBOutlet UIWebView *wvNews;
	NSString *newsId;
	News *news;
}

@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblTime;
@property (nonatomic, retain) IBOutlet UIWebView *wvNews;
@property (nonatomic, retain) NSString *newsId;

- (void)retrieveNewsDetailData;

@end

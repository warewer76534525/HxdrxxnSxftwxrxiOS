//
//  SignalDescriptionview.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/8/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSPreviewScrollView.h"
#import "TapImage.h"
#import "BaseViewController.h"
#import "ImageTempStorer.h"

@protocol ImageDownloadDelegate
- (void)finishedWithImages:(NSArray *)images;
@end


@interface SignalDescriptionview : BaseViewController <BSPreviewScrollViewDelegate, UIScrollViewDelegate, UIWebViewDelegate, ImageDownloadDelegate> {
	BSPreviewScrollView *scrollViewPreview;
	NSMutableArray *images;
    NSMutableArray *realImgs;
	UIScrollView *scrollViewDetail;
	UIWebView *webViewDetail;
	IBOutlet UIView *viewLoading;
	NSString *receivedJson;
	NSArray *imageUrls;
	NSString *signalId;
    ImageTempStorer *imageStorer;
    BOOL initiated;
    UIInterfaceOrientation lastOrientation;
    
}
@property (nonatomic, retain) NSArray *images;
@property (nonatomic, retain) IBOutlet UIView *viewLoading;
@property (nonatomic, retain) NSString *signalId;

- (void)retrieveSignalDetailData;

@end

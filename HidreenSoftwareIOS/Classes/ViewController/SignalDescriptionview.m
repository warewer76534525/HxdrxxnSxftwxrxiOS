//
//  SignalDescriptionview.m
//  HidreenSoftware
//
//  Created by Hidreen International on 8/8/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "SignalDescriptionview.h"
#import "HttpConnection.h"
#import "DataProcessor.h"
#import "ImageUtil.h"
#import "ImageDownloader.h"
#import "HomePageView.h"
#import "DataStorer.h"

#define SIGNAL_DETAIL_URL @"http://amygdalahd.com/index.php/m/signals/view/"

@implementation SignalDescriptionview
@synthesize images, viewLoading, signalId;

- (void)viewDidLoad {
    [super viewDidLoad];
    imageStorer = [ImageTempStorer GetInstance];
	self.navigationController.navigationBarHidden = NO;
	images = [[NSMutableArray alloc] init];
    realImgs = [[NSMutableArray alloc] init];
	
	//Creating the scroll view
	scrollViewDetail = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)]; 
	webViewDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
	webViewDetail.delegate = self;
    lastOrientation = UIInterfaceOrientationPortrait;
    
	[self retrieveSignalDetailData];
}

- (void)showLoading {
	viewLoading.hidden = NO;
}

- (void)hideLoading {
	viewLoading.hidden = YES;
}

- (void)retrieveSignalDetailData {
	[self showLoading];
	HttpConnection *conn = [[HttpConnection alloc] initWithDelegate:self];
	NSString *urlDetail = [NSString stringWithFormat:@"%@%@", SIGNAL_DETAIL_URL, self.signalId];
	[conn startAccessWithUrl:urlDetail];
	[conn release];
}

- (void)downloadImageWithUrl:(NSString *)urlImage {
	HttpConnection *conn = [[HttpConnection alloc] initWithDelegate:self];
	[conn startAccessWithUrl:urlImage];
	[conn release];
}

- (void)loadWebDescription {
	DataProcessor *processor = [[DataProcessor alloc] init];
	NSString *desc = [processor getMetaSignalFromJson:receivedJson];
	desc = [desc stringByReplacingOccurrencesOfString:@"\n" withString:@"</br>"];
	[webViewDetail loadHTMLString:desc baseURL:nil];
	webViewDetail.dataDetectorTypes = NO;
	[processor release];
}

- (void)populateImagePreviewerWithStartingY:(CGFloat)y imagePreviewerWidth:(CGFloat)width imagePreviewerHeight:(CGFloat)height {
	scrollViewPreview = [[BSPreviewScrollView alloc] initWithFrameAndPageSize:CGRectMake(0, y, width, height) pageSize:CGSizeMake(320, 240)];
	[scrollViewPreview setBackgroundColor:[UIColor darkGrayColor]];
	scrollViewPreview.delegate = self;
	[scrollViewDetail addSubview:scrollViewPreview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString *output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
	NSLog(@"webview height: %@", output);
	CGFloat webHeight = [output floatValue];
	CGRect newWebViewRect = CGRectMake(0, 0, self.view.frame.size.width, webHeight);
	[webViewDetail setFrame:newWebViewRect];
    
    if (!initiated) {
        //UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
        //lastOrientation = orientation;
        
        if (lastOrientation == UIInterfaceOrientationPortrait || lastOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            [scrollViewDetail addSubview:webViewDetail];
            
            CGFloat imagePreviewerHeight = 0;
            CGFloat padding = 45;
            if (imageUrls != nil && imageUrls.count > 0) {
                imagePreviewerHeight = 240;
                [self populateImagePreviewerWithStartingY:webHeight imagePreviewerWidth:320 imagePreviewerHeight:imagePreviewerHeight];
            }
            NSLog(@"Heights: %f, %f", webHeight, imagePreviewerHeight);
            scrollViewDetail.contentSize = CGSizeMake(self.view.frame.size.width, webHeight + imagePreviewerHeight + padding);
            [self.view addSubview:scrollViewDetail];
            [self hideLoading];
            initiated = YES;
        } else {
            [scrollViewDetail addSubview:webViewDetail];
            
            [scrollViewDetail setFrame:CGRectMake(0, 0, 480, 270)];
            [webViewDetail setFrame:CGRectMake(0, 0, 480, 1)];
            [self loadWebDescription];
            
            CGFloat imagePreviewerHeight = 0;
            NSString *output = [webViewDetail stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
            CGFloat y = [output floatValue] - 150;
            
            [scrollViewPreview removeFromSuperview];
            [scrollViewPreview release];
            //[self resizeImagesWidth:320 height:240];
            
            if (imageUrls != nil && imageUrls.count > 0) {
                imagePreviewerHeight = 240;
                [self populateImagePreviewerWithStartingY:y imagePreviewerWidth:480 imagePreviewerHeight:imagePreviewerHeight];
                [scrollViewPreview setPageSize:CGSizeMake(320, imagePreviewerHeight)];
                //[scrollViewPreview setFrame:CGRectMake(0, y, 480, imagePreviewerHeight)];
            }
            scrollViewDetail.contentSize = CGSizeMake(480, y + imagePreviewerHeight + 5);
            [self hideLoading];
            
            [self.view addSubview:scrollViewDetail];
            
            initiated = YES;
        }
        
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
 	[super connection:connection didFailWithError:error];
	[self hideLoading];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
 	NSString *json = [[NSString alloc] initWithData:super.receivedData encoding:NSUTF8StringEncoding];
	DataProcessor *processor = [[DataProcessor alloc] init];
	
	if ([[processor getResponseStatusWithJson:json] isEqualToString:@"0"]) {
		[super handleSessionExpiredWithMessage:[processor getResponseMessageWithJson:json]];
	} else {
		receivedJson = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
		imageUrls = [processor getImagesFromJson:receivedJson];
		[imageUrls retain];
		
		if (imageUrls != nil && imageUrls.count > 0) {
			ImageDownloader *downloader = [[ImageDownloader alloc] initWithUrls:imageUrls];
			downloader.delegate = self;
			[downloader startDownload];
			[downloader release];
		} else {
			[self loadWebDescription];
		}
	}
	[processor release];
	[json release];
}

- (void)finishedWithImages:(NSArray *)imgs {
    ImageUtil *imageUtil = [[ImageUtil alloc] init];
    for (int i = 0; i < imgs.count; i++) {
        UIImage *scaledImage = [imageUtil image:[imgs objectAtIndex:i] scaleToSize:CGSizeMake(295, 221)];
        [images addObject:scaledImage];
        [realImgs addObject:[imgs objectAtIndex:i]];
    }
    [imageUtil release];
    
	NSLog(@"finished Download %d images", images.count);
	[imageStorer addImage:imgs];
    
	[self loadWebDescription];
}

- (void)resizeImagesWidth:(CGFloat)width height:(CGFloat)height {
    ImageUtil *imageUtil = [[ImageUtil alloc] init];
    [images removeAllObjects];
    for (int i = 0; i < realImgs.count; i++) {
        UIImage *scaledImage = [imageUtil image:[realImgs objectAtIndex:i] scaleToSize:CGSizeMake(width, height)];
        [images addObject:scaledImage];
    }
    [imageUtil release];
    
	NSLog(@"finished Download %d images", images.count);
}

-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index
{
    NSLog(@"imageViewed");
	CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, 320, 240);
    //CGRect imageViewFrame = CGRectMake(0.0f, 0.0f, 400, 260);
	
	// TapImage is a subclassed UIImageView that catch touch/tap events 
	TapImage *imageView = [[[TapImage alloc] initWithFrame:imageViewFrame] autorelease];
    imageView.index = index;
	imageView.userInteractionEnabled = YES;
	imageView.image = [self.images objectAtIndex:index];
	imageView.contentMode = UIViewContentModeCenter;
    imageView.parentView = self;
    
	return imageView;
}

-(int)itemCount:(BSPreviewScrollView*)scrollView
{
	return [self.images count];
}

-(void)fitPortrait {
    [scrollViewDetail setFrame:CGRectMake(0, 0, 320, 410)];
    [webViewDetail setFrame:CGRectMake(0, 0, 320, 1)];
    [self loadWebDescription];
    
    CGFloat imagePreviewerHeight = 0;
    NSString *output = [webViewDetail stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    CGFloat y = [output floatValue] + 185;
    
    [scrollViewPreview removeFromSuperview];
    [scrollViewPreview release];
    //[self resizeImagesWidth:320 height:240];
    
    if (imageUrls != nil && imageUrls.count > 0) {
        imagePreviewerHeight = 240;
        [self populateImagePreviewerWithStartingY:y imagePreviewerWidth:320 imagePreviewerHeight:imagePreviewerHeight];
        [scrollViewPreview setPageSize:CGSizeMake(320, imagePreviewerHeight)];
        //[scrollViewPreview setFrame:CGRectMake(0, y, 480, imagePreviewerHeight)];
    }
    scrollViewDetail.contentSize = CGSizeMake(320, y + imagePreviewerHeight);
    [self hideLoading];
}

-(void)fitLandscape {
    [scrollViewDetail setFrame:CGRectMake(0, 0, 480, 270)];
    [webViewDetail setFrame:CGRectMake(0, 0, 480, 1)];
    [self loadWebDescription];
    
    CGFloat imagePreviewerHeight = 0;
    NSString *output = [webViewDetail stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    CGFloat y = [output floatValue] - 255;
    
    [scrollViewPreview removeFromSuperview];
    [scrollViewPreview release];
    //[self resizeImagesWidth:320 height:240];
    
    if (imageUrls != nil && imageUrls.count > 0) {
        imagePreviewerHeight = 240;
        [self populateImagePreviewerWithStartingY:y imagePreviewerWidth:480 imagePreviewerHeight:imagePreviewerHeight];
        [scrollViewPreview setPageSize:CGSizeMake(320, imagePreviewerHeight)];
        //[scrollViewPreview setFrame:CGRectMake(0, y, 480, imagePreviewerHeight)];
    }
    scrollViewDetail.contentSize = CGSizeMake(480, y + imagePreviewerHeight + 5);
    [self hideLoading];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"Rotating..");
    if (initiated) {
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            if (lastOrientation == UIInterfaceOrientationPortrait || lastOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                [self fitLandscape];
            }
        } else {
            if (lastOrientation == UIInterfaceOrientationLandscapeRight || lastOrientation == UIInterfaceOrientationLandscapeLeft) {
                [self fitPortrait];
            }
        }
    } else {
        if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
            [viewLoading setFrame:CGRectMake(175, 230, 130, 40)];
        } else {
            [viewLoading setFrame:CGRectMake(120, 172, 130, 40)];
        }
    }
    lastOrientation = toInterfaceOrientation;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Will appear");
    if(initiated){
        UIInterfaceOrientation orientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
        
        if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft) {
            if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
                if (lastOrientation == UIInterfaceOrientationPortrait || lastOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                    NSLog(@"Fit landscape");
                    [self fitLandscape];
                }
            } else {
                if (lastOrientation == UIInterfaceOrientationLandscapeLeft || lastOrientation == UIInterfaceOrientationLandscapeRight) {
                    NSLog(@"Fit portrait");
                    [self fitPortrait];
                }
            }
            lastOrientation = orientation;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        NSLog(@"Will dissapear");
        [imageStorer clearImages];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	[scrollViewPreview didReceiveMemoryWarning];
}

- (void)dealloc 
{
    [realImgs release];
	[signalId release];
	[imageUrls release];
	[receivedJson release];
	[viewLoading release];
	[webViewDetail release];
	[scrollViewDetail release];
	[scrollViewPreview release];
	[images release];
    [super dealloc];
}

@end

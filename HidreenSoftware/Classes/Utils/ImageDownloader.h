//
//  ImageDownloader.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/9/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SignalDescriptionview.h"

@interface ImageDownloader : NSObject {
	id<ImageDownloadDelegate> delegate;
	NSArray *urls;
	NSMutableData *receivedData;
	NSMutableArray *downloadedImages;
	NSInteger currentDownload;
}

@property (nonatomic, retain) id<ImageDownloadDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *downloadedImages;
@property (nonatomic, retain) NSMutableData *receivedData;

- (id) initWithUrls:(NSArray *)urlArr;
- (void)startDownload;

@end

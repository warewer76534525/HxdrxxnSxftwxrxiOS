//
//  HttpConnection.h
//  HidreenSoftware
//
//  Created by Hidreen International on 8/3/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HttpConnection : NSObject {
	id delegate;
}

- (id) initWithDelegate:(id)delval;
- (void)startAccessWithUrl:(NSString *)urlString;
- (void)postDataWithUrl:(NSString *)urlString parameter:(NSString *)param;

@end

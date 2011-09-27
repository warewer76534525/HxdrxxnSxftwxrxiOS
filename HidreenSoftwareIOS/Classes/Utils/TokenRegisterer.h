//
//  TokenRegisterer.h
//  HidreenSoftware
//
//  Created by Jogi Silalahi on 9/13/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenRegisterer : NSObject {
    NSMutableData *receivedData;
}

- (void)registerToken:(NSString *)token withEmail:(NSString *)email;
    
@end

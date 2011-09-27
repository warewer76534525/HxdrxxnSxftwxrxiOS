//
//  ImageTempStorer.h
//  HidreenSoftware
//
//  Created by Jogi Silalahi on 9/18/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTempStorer : NSObject {
}
    
+ (ImageTempStorer *)GetInstance;
- (void) addImage:(NSArray *)imgs;
- (NSArray *) getImages;
- (void) clearImages;

@end

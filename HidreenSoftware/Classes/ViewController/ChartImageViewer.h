//
//  ChartImageViewer.h
//  HidreenSoftware
//
//  Created by Jogi Silalahi on 9/18/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartImageViewer : UIViewController <UIScrollViewDelegate>{
    IBOutlet UIScrollView *sv;
    UIImageView *tempImageView;
    NSArray *images;
    NSUInteger currentIndex;
    IBOutlet UIBarButtonItem *lblNavigation;
}

- (void)setImages:(NSArray *)imgs;
- (IBAction)reset;
- (IBAction)next;
- (IBAction)prev;
- (IBAction)close;
- (void)resetIgnoreAnimation;
- (void)setInitialIndex:(NSUInteger)index;

@end

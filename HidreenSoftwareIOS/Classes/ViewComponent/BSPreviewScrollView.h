
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class BSPreviewScrollView;

@protocol BSPreviewScrollViewDelegate
@required
-(UIView*)viewForItemAtIndex:(BSPreviewScrollView*)scrollView index:(int)index;
-(int)itemCount:(BSPreviewScrollView*)scrollView;

@end

@interface BSPreviewScrollView : UIView<UIScrollViewDelegate> {
	UIScrollView *scrollView;
	id<BSPreviewScrollViewDelegate, NSObject> delegate;
	NSMutableArray *scrollViewPages;
	BOOL firstLayout;
	CGSize pageSize;
	BOOL dropShadow;
	UIPageControl *pageControl;
    CGFloat viewWidth;
}
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, assign) id<BSPreviewScrollViewDelegate, NSObject> delegate;
@property (nonatomic, assign) CGSize pageSize;
@property (nonatomic, assign) BOOL dropShadow;
@property (nonatomic, retain) UIPageControl *pageControl;

- (void)didReceiveMemoryWarning;
- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size;

@end


#import "BSPreviewScrollView.h"

#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)
#define PAGECONTROL_HEIGHT 10.0
#define PAGECONTROL_DOT_WIDTH 10.0

@implementation BSPreviewScrollView
@synthesize scrollView, pageSize, dropShadow, delegate, pageControl;

- (void)awakeFromNib
{
	firstLayout = YES;
	dropShadow = YES;
}

- (id)initWithFrame:(CGRect)frame
{
	if(self = [super initWithFrame:frame])
	{
		firstLayout = YES;
		dropShadow = YES;
        viewWidth = frame.size.width;
	}
	
	return self;
}

- (id)initWithFrameAndPageSize:(CGRect)frame pageSize:(CGSize)size 
{    
	if (self = [self initWithFrame:frame]) 
	{
		self.pageSize = size;
        viewWidth = frame.size.width;
    }
    return self;
}

-(void)loadPage:(int)page
{
	// Sanity checks
    if (page < 0) return;
    if (page >= [scrollViewPages count]) return;
	
	// Check if the page is already loaded
	UIView *view = [scrollViewPages objectAtIndex:page];
	
	// if the view is null we request the view from our delegate
	if ((NSNull *)view == [NSNull null]) 
	{
		view = [delegate viewForItemAtIndex:self index:page];
		[scrollViewPages replaceObjectAtIndex:page withObject:view];
	}
	
	// add the controller's view to the scroll view	if it's not already added
	if (view.superview == nil) 
	{
		// Position the view in our scrollview
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = viewFrame.size.width * page;
		viewFrame.origin.y = 0;
		
		view.frame = viewFrame;
		
		[self.scrollView addSubview:view];
	}
}

// Shadow code from http://cocoawithlove.com/2009/08/adding-shadow-effects-to-uitableview.html
- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse
{
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    CGRect newShadowFrame =	CGRectMake(0, 0, self.frame.size.width, inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
    newShadow.frame = newShadowFrame;
    CGColorRef darkColor =[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:inverse ? (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT) * 0.5 : 0.5].CGColor;
    CGColorRef lightColor =	[self.backgroundColor colorWithAlphaComponent:0.0].CGColor;
    newShadow.colors = [NSArray arrayWithObjects: (id)(inverse ? lightColor : darkColor), (id)(inverse ? darkColor : lightColor), nil];
    return newShadow;
}

- (void)layoutSubviews
{
	// We need to do some setup once the view is visible. This will only be done once.
	if(firstLayout)
	{
		// Add drop shadow to add that 3d effect
		if(dropShadow)
		{
//			CAGradientLayer *topShadowLayer = [self shadowAsInverse:NO];
//			CAGradientLayer *bottomShadowLayer = [self shadowAsInverse:YES];
//			[self.layer insertSublayer:topShadowLayer atIndex:0];
//			[self.layer insertSublayer:bottomShadowLayer atIndex:0];
//			
//			[CATransaction begin];
//			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
//			
//			// Position and stretch the shadow layers to fit
//			CGRect topShadowLayerFrame = topShadowLayer.frame;
//			topShadowLayerFrame.size.width = self.frame.size.width;
//			topShadowLayerFrame.origin.y = 0;
//			topShadowLayer.frame = topShadowLayerFrame;
//			
//			CGRect bottomShadowLayerFrame = bottomShadowLayer.frame;
//			bottomShadowLayerFrame.size.width = self.frame.size.width;
//			bottomShadowLayerFrame.origin.y = self.frame.size.height - bottomShadowLayer.frame.size.height;
//			bottomShadowLayer.frame = bottomShadowLayerFrame;
//			
//			[CATransaction commit];
		}
			  
		// Position and size the scrollview. It will be centered in the view. ; The origin y is decreased to give page control the space in the bottom
		CGRect scrollViewRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
		scrollViewRect.origin.x = ((self.frame.size.width - pageSize.width) / 2);
		scrollViewRect.origin.y = ((self.frame.size.height - pageSize.height) / 2) - (PAGECONTROL_HEIGHT / 2);
		 
		scrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
		scrollView.clipsToBounds = NO; // Important, this creates the "preview"
		scrollView.pagingEnabled = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.delegate = self;
		
		[self addSubview:scrollView];		
		
		int pageCount = [delegate itemCount:self];
		scrollViewPages = [[NSMutableArray alloc] initWithCapacity:pageCount];
		
		//add pageControl to display little dot in the bottom of view
        NSLog(@"Image previewer width: %f", self.scrollView.frame.size.width);
		CGRect pageControlRect = CGRectMake(viewWidth / 2 - (pageCount * PAGECONTROL_DOT_WIDTH / 2), scrollView.frame.size.height - PAGECONTROL_HEIGHT, pageCount * PAGECONTROL_DOT_WIDTH, PAGECONTROL_HEIGHT);
		pageControl = [[UIPageControl alloc] initWithFrame: pageControlRect];
		pageControl.userInteractionEnabled = NO;
		pageControl.numberOfPages = pageCount;
		pageControl.currentPage = 0;
		[self addSubview:pageControl];
		//
		
		// Fill our pages collection with empty placeholders
		for(int i = 0; i < pageCount; i++)
		{
			[scrollViewPages addObject:[NSNull null]];
		}
		
		// Calculate the size of all combined views that we are scrolling through 
		self.scrollView.contentSize = CGSizeMake([delegate itemCount:self] * self.scrollView.frame.size.width, scrollView.frame.size.height);
		
		// Load the first two pages
		[self loadPage:0];
		[self loadPage:1];
		
		firstLayout = NO;
	}
}



- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(scrollView.frame, point)) {
		return self.scrollView;
	}
	
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}

-(int)currentPage
{
	// Calculate which page is visible 
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	return page;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

-(void)scrollViewDidScroll:(UIScrollView *)sv
{
	int page = [self currentPage];
	
	
	// Load the visible and neighbouring pages 
	[self loadPage:page-1];
	[self loadPage:page];
	[self loadPage:page+1];
	
	//populate page controller
	pageControl.currentPage = page;
}

#pragma mark -
#pragma mark Memory management

// didReceiveMemoryWarning is not called automatically for views, 
// make sure you call it from your view controller
- (void)didReceiveMemoryWarning 
{
	// Calculate the current page in scroll view
    int currentPage = [self currentPage];
	
	// unload the pages which are no longer visible
	for (int i = 0; i < [scrollViewPages count]; i++) 
	{
		UIView *viewController = [scrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
		{
			if(i < currentPage-1 || i > currentPage+1)
			{
				[viewController removeFromSuperview];
				[scrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
			}
		}
	}
}

- (void)dealloc 
{
	[pageControl release];
	[scrollViewPages release];
	[scrollView release];
    [super dealloc];
}


@end

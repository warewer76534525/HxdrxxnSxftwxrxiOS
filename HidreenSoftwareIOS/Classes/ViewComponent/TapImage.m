

#import "TapImage.h"
#import "ChartImageViewer.h"
#import "ImageTempStorer.h"

@implementation TapImage
@synthesize index, parentView;

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {    
    ImageTempStorer *imgStorer = [ImageTempStorer GetInstance];
    ChartImageViewer *view = [[ChartImageViewer alloc] init];
    [view setImages:[imgStorer getImages]];
    [view setInitialIndex:index];
    [parentView.navigationController pushViewController:view animated:YES];
    [view release];
}

- (void) dealloc {
    //[parentView release];
    [super dealloc];
}

@end

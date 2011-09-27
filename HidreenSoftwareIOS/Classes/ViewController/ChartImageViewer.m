//
//  ChartImageViewer.m
//  HidreenSoftware
//
//  Created by Jaka Putra on 9/18/11.
//  Copyright 2011 Hidreen. All rights reserved.
//

#import "ChartImageViewer.h"

@implementation ChartImageViewer

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

- (void)setImages:(NSArray *)imgs {
    images = imgs;
    NSLog(@"images count: %d", images.count);
}

- (void)updateCurrent {
    lblNavigation.title = [NSString stringWithFormat:@"%d/%d", currentIndex + 1, images.count];
    UIImageView *imgCurrent = [[UIImageView alloc] initWithImage:[images objectAtIndex:currentIndex]];
    tempImageView = imgCurrent;
    
    for(UIView *subview in [sv subviews]) {
        [subview removeFromSuperview];
    }
    [sv addSubview:tempImageView];
    [sv reloadInputViews];
    [self resetIgnoreAnimation];
    [imgCurrent release];
}

- (void)setInitialIndex:(NSUInteger)index {
    currentIndex = index;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self updateCurrent];
    
    sv.contentSize = CGSizeMake(tempImageView.frame.size.width, tempImageView.frame.size.height);
    sv.maximumZoomScale = 2.0;
    sv.minimumZoomScale = 0.5;
    sv.clipsToBounds = YES;
    sv.delegate = self;
    sv.alpha = 0.0;
    [sv setZoomScale:0.86];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration: 2.0];
    sv.alpha = 1.0;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return tempImageView;
}

- (void)reset {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 1.0];
    [sv setZoomScale:0.86];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)resetIgnoreAnimation {
    [sv setZoomScale:0.86];
}

- (void)next {
    if (currentIndex < images.count - 1) {
        currentIndex += 1;
        [self updateCurrent];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:sv cache:YES];
        [UIView commitAnimations];
    }
}

- (void)prev {
    if (currentIndex > 0) {
        currentIndex -= 1;
        [self updateCurrent];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:sv cache:YES];
        [UIView commitAnimations];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) close {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) dealloc {
    NSLog(@"dealloc executed");
    [lblNavigation release];
    //[tempImageView release];
    //[images release];
    [sv release];
    [super dealloc];
}

@end

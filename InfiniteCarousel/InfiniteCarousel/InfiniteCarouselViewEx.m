//
//  InfiniteCarouselViewEx.m
//  InfiniteCarousel
//
//  Created by okyes will on 2017/9/4.
//  Copyright © 2017年 okyes will. All rights reserved.
//

#import "InfiniteCarouselViewEx.h"
#import "SFWeakTimer.h"

@interface InfiniteCarouselViewEx () <UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    UIPageControl *pageControl;
    
    UIImageView *leftImageView;
    UIImageView *middleImageView;
    UIImageView *rightImageView;
    
    NSTimer *timer;
    
    NSInteger currentIndex;
    NSInteger count;
    
}

@end

@implementation InfiniteCarouselViewEx

static const int viewNumber = 3;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        currentIndex = 0;
    }
    
    return self;
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    count = _imageArr.count;
    
    //
    [self createScrollView];
    
    //
    [self createTimer];
    
    //
    [self createPageControl];
}

- (void)createPageControl {
    CGFloat pageControlWidth = 80.f;
    CGFloat pageControlHeight = 20.f;
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20.f, self.frame.size.height - pageControlHeight, pageControlWidth, pageControlHeight)];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    pageControl.numberOfPages = count;
    [self addSubview:pageControl];
}

- (void)createTimer {
    timer = [SFWeakTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    [timer invalidate];
    timer = nil;
}

- (void)timerAction {
    currentIndex++;
    [myScrollView scrollRectToVisible:CGRectMake(self.frame.size.width * 2, 0.f, self.frame.size.width, self.frame.size.height) animated:YES];
}


#pragma mark -

- (void)createScrollView {
    //
    myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    myScrollView.pagingEnabled = YES;
    myScrollView.bounces = NO;
    myScrollView.backgroundColor = [UIColor redColor];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = YES;
    myScrollView.delegate = self;
    myScrollView.contentSize = CGSizeMake(self.frame.size.width * viewNumber, self.frame.size.height);
    [self addSubview:myScrollView];
    
    //
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
    leftImageView.image = [UIImage imageNamed:_imageArr[count-1]];
    
    middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width, 0.f, self.frame.size.width, self.frame.size.height)];
    middleImageView.image = [UIImage imageNamed:_imageArr[0]];
    
    rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * 2, 0.f, self.frame.size.width, self.frame.size.height)];
    rightImageView.image = [UIImage imageNamed:_imageArr[1]];
    
    [myScrollView addSubview:leftImageView];
    [myScrollView addSubview:middleImageView];
    [myScrollView addSubview:rightImageView];
    
    //
    myScrollView.contentOffset = CGPointMake(self.frame.size.width, 0.f);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //
    if (scrollView.contentOffset.x == self.frame.size.width * 2) {
        currentIndex++;
        [self resetImages];
    } else if (scrollView.contentOffset.x == 0) {
        currentIndex += count - 1;
        [self resetImages];
    }
    
    NSLog(@"scrollViewDidEndDecelerating");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self resetImages];
    NSLog(@"scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //NSLog(@"scrollViewDidScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self createTimer];
}



#pragma mark -

- (void)resetImages {
    
    pageControl.currentPage = currentIndex % count;
    
    leftImageView.image   = [UIImage imageNamed:_imageArr[(currentIndex-1) % count]];
    middleImageView.image = [UIImage imageNamed:_imageArr[currentIndex % count]];
    rightImageView.image  = [UIImage imageNamed:_imageArr[(currentIndex+1) % count]];
    
    myScrollView.contentOffset = CGPointMake(self.frame.size.width, 0.f);
}

@end
















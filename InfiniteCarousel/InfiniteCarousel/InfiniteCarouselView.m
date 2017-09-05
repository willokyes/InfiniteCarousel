//
//  InfiniteCarouselView.m
//  InfiniteCarousel
//
//  Created by okyes will on 2017/8/31.
//  Copyright © 2017年 okyes will. All rights reserved.
//

#import "InfiniteCarouselView.h"
#import "SFWeakTimer.h"

@interface UIImageView (xxx)

@end

@implementation UIImageView (xxx)

- (void)dealloc {
    NSLog(@"UIImageView (xxx) dealloc");
}

@end



@interface InfiniteCarouselView () {
    NSInteger currentIndex;
    NSInteger count;
    NSTimer *timer;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageCtrl;

@end

@implementation InfiniteCarouselView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blueColor];
        currentIndex = 0;
    }
    
    return self;
}

- (void)setImageArr:(NSArray *)imageArr {
    _imageArr = imageArr;
    count = _imageArr.count;
    
    [self addSubview:self.collectionView];
    
    self.collectionView.contentOffset = CGPointMake(self.frame.size.width, 0.f);
    
    [self createTimer];
    
    [self addSubview:self.pageCtrl];
}

- (void)dealloc {
    NSLog(@"InfiniteCarouselView: dealloc");
    
    [timer invalidate];
    //timer = nil;
}

- (void)createTimer {
    timer = [SFWeakTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)createTimer3 {
    __weak typeof(self) weakSelf = self;
    timer = [SFWeakTimer scheduledTimerWithTimeInterval:2.f block:^(id userInfo) {
        
        //[self timerAction];

        [weakSelf timerAction];
        
        NSLog(@"SFWeakTimer:block");

    } userInfo:nil repeats:YES];
}

- (void)createTimer2 { // no
    __weak typeof(self) weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.f target:weakSelf selector:@selector(timerAction) userInfo:nil repeats:YES];
}

- (void)createTimer1 {
    //__weak typeof(self) weakSelf = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:2.f repeats:YES block:^(NSTimer * _Nonnull timer) {
        [self timerAction];
        //[weakSelf timerAction];
        
        NSLog(@"NSTimer:block");
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    
    currentIndex++;
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    
    NSLog(@"timerAction");

}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return count + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"willokyes" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, self.frame.size.height)];
    [cell addSubview:imageView];
    
    if (indexPath.row == 0) {
        imageView.image = [UIImage imageNamed:_imageArr[count - 1]];
    } else if (indexPath.row == count + 1) {
        imageView.image = [UIImage imageNamed:_imageArr[0]];
    } else {
        imageView.image = [UIImage imageNamed:_imageArr[indexPath.row - 1]];
    }
    
    //NSLog(@"indexPath.row: %ld", (long)indexPath.row);
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == self.frame.size.width * (count + 1))
    {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
        currentIndex = 1;
    }
    else if (scrollView.contentOffset.x == 0)
    {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        currentIndex = count;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == self.frame.size.width * (count + 1))
    {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        currentIndex = 1;
    }
    
    //NSLog(@"scrollViewDidEndScrollingAnimation: scrollView.contentOffset.x: %ld", (long)scrollView.contentOffset.x);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //NSLog(@"DidScroll: scrollView.contentOffset.x: %ld", (long)scrollView.contentOffset.x);
    
    NSInteger tmpIndex = scrollView.contentOffset.x / self.frame.size.width;
    tmpIndex = tmpIndex - 1;
    _pageCtrl.currentPage = tmpIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [timer invalidate];
    timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self createTimer];
}


#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor greenColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"willokyes"];
    }
    return _collectionView;
}

- (UIPageControl *)pageCtrl {
    if (!_pageCtrl) {
        CGFloat pageWidth = 80.f;
        CGFloat pageHeight = 20.f;
        
        _pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(20.f, self.frame.size.height-pageHeight, pageWidth, pageHeight)];
        _pageCtrl.numberOfPages = _imageArr.count;
        _pageCtrl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageCtrl;
}

@end



















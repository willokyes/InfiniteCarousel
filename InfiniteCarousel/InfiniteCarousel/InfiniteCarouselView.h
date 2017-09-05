//
//  InfiniteCarouselView.h
//  InfiniteCarousel
//
//  Created by okyes will on 2017/8/31.
//  Copyright © 2017年 okyes will. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfiniteCarouselView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *imageArr;

@end

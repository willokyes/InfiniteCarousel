//
//  ViewController.m
//  InfiniteCarousel
//
//  Created by okyes will on 2017/8/31.
//  Copyright © 2017年 okyes will. All rights reserved.
//

#import "ViewController.h"
#import "InfiniteCarouselView.h"
#import "InfiniteCarouselViewEx.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"无限轮播";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //
    InfiniteCarouselViewEx *icView = [[InfiniteCarouselViewEx alloc] initWithFrame:CGRectMake(0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2)];
    icView.imageArr = @[@"0", @"1", @"2", @"3", @"4"];
    [self.view addSubview:icView];
    
    //
//    InfiniteCarouselView *icView = [[InfiniteCarouselView alloc] initWithFrame:CGRectMake(0, 64.0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width/2)];
//    icView.imageArr = @[@"0", @"1", @"2", @"3", @"4"];
//    [self.view addSubview:icView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

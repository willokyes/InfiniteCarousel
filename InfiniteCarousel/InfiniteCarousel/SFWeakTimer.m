//
//  SFWeakTimer.m
//  InfiniteCarousel
//
//  Created by okyes will on 2017/9/2.
//  Copyright © 2017年 okyes will. All rights reserved.
//

#import "SFWeakTimer.h"

@interface SFWeakTimerTarget : NSObject

@property (weak, nonatomic) id target;
@property (assign, nonatomic) SEL selector;
@property (weak, nonatomic) NSTimer *timer;

- (void)fire:(NSTimer *)timer;
@end

@implementation SFWeakTimerTarget

- (void)dealloc {
    NSLog(@"SFWeakTimerTarget dealloc");
}

- (void)fire:(NSTimer *)timer {
    
    if (self.target && [self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:timer.userInfo afterDelay:0.0f];
#pragma clang diagnostic pop
    } else {
        [self.timer invalidate];
    }
}
@end

@implementation SFWeakTimer

- (void)dealloc {
    NSLog(@"SFWeakTimer dealloc");
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    
    SFWeakTimerTarget *timerTarget = [[SFWeakTimerTarget alloc] init];
    timerTarget.target = aTarget;
    timerTarget.selector = aSelector;
    timerTarget.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:timerTarget selector:@selector(fire:) userInfo:userInfo repeats:repeats];
    
    return timerTarget.timer;
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(SFWeakTimerBlock)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats {
    return [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(sf_timerUsingBlockWithObjects:) userInfo:@[[block copy]] repeats:repeats];
}

+ (void)sf_timerUsingBlockWithObjects:(NSArray *)objects {
    SFWeakTimerBlock block = [objects firstObject];
    id userInfo = [objects lastObject];
    
    if (block) {
        block(userInfo);
    }
}
@end























//
//  SFWeakTimer.h
//  InfiniteCarousel
//
//  Created by okyes will on 2017/9/2.
//  Copyright © 2017年 okyes will. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SFWeakTimerBlock)(id userInfo);

@interface SFWeakTimer : NSObject

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     target:(id)aTarget
                                   selector:(SEL)aSelector
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      block:(SFWeakTimerBlock)block
                                   userInfo:(id)userInfo
                                    repeats:(BOOL)repeats;
@end

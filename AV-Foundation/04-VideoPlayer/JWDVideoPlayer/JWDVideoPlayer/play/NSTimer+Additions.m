//
//  NSTimer+Additions.m
//  JWDVideoPlayer
//
//  Created by 伟东 on 2020/6/16.
//  Copyright © 2020 yixiajwd. All rights reserved.
//

#import "NSTimer+Additions.h"

@implementation NSTimer (Additions)

+ (void)executeTimerBlock:(NSTimer *)timer {
    TimerFireBlock block = [timer userInfo];
    block();
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)interval firing:(TimerFireBlock)fireBlock {
    return [self scheduledTimerWithTimeInterval:interval repeating:NO firing:fireBlock];
}

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval repeating:(BOOL)repeat firing:(TimerFireBlock)fireBlock {
    id block = [fireBlock copy];
    return [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(executeTimerBlock:) userInfo:block repeats:repeat];
}
@end

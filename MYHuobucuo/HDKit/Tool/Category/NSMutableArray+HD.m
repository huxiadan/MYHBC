//
//  NSMutableArray+HD.m
//  Huobucuo
//
//  Created by hudan on 16/8/31.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "NSMutableArray+HD.h"

@implementation NSMutableArray (HD)

- (void)addObjectSafe:(id)object
{
    if (object) {
        [self addObject:object];
    }
    else {
        NSAssert(NO, @"插入对象为空!");
    }
}

- (id)objectAtIndexSafe:(NSUInteger)index
{
    if (index > [self count] - 1) {
        NSAssert(NO, @"索引值越界了!");
        return nil;
    }
    else {
        return [self objectAtIndex:index];
    }
}

@end

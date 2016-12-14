//
//  NSArray+HD.m
//  Huobucuo
//
//  Created by hudan on 16/9/6.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "NSArray+HD.h"

@implementation NSArray (HD)

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

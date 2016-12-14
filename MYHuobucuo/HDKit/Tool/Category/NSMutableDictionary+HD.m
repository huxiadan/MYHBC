//
//  NSMutableDictionary+HD.m
//  Huobucuo
//
//  Created by hudan on 16/8/31.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "NSMutableDictionary+HD.h"

@implementation NSMutableDictionary (HD)

- (void)setObjectSafe:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
    else {
        NSAssert(NO, @"设置的 value 值为空!");
    }
}

@end

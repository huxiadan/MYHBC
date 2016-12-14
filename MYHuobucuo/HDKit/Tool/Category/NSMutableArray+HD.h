//
//  NSMutableArray+HD.h
//  Huobucuo
//
//  Created by hudan on 16/8/31.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (HD)


/**
 向可变数组添加对象,防止插入 nil 对象导致崩溃

 @param object 要插入的对象
 */
- (void)addObjectSafe:(id)object;


/**
 获取数组中对应索引的对象,防止索引越界导致程序崩溃
 
 @param index 索引值
 
 @return 数组中索引值对应的对象
 */
- (id)objectAtIndexSafe:(NSUInteger)index;

@end

//
//  HDControllersView.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ViewControllerMoveBlock)(NSInteger index);

@interface HDControllersView : UIScrollView

@property (nonatomic, strong) NSArray *childControllers;               // 子控制器数组
@property (nonatomic, copy) ViewControllerMoveBlock viewMoveBlock;     // 视图移动的block

/**
 *  初始化
 *
 *  @param frame        视图的 frame
 *  @param controllers  控制器数组
 *
 *  @return             实例化的对象
 */
- (instancetype)initFrame:(CGRect)frame controllers:(NSArray *)controllers;

/**
 *  移动到指定的控制器视图
 *
 *  @param index 索引值
 */
- (void)moveToController:(NSInteger)index;

@end

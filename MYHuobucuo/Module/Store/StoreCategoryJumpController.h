//
//  StoreCategoryJumpController.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/5.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺 ---分类跳转
 */

#import "BaseViewController.h"

@interface StoreCategoryJumpController : BaseViewController


/**
 初始化

 @param shopId 店铺 id
 @param categoryTitle 分类
 @return 对象
 */
- (instancetype)initWithShopId:(NSString *)shopId categoryTitle:(NSString *)categoryTitle mainView:(UIView *)mainView;

@end

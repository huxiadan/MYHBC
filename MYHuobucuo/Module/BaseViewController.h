//
//  BaseViewController.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MYProgressHUD.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;  // 通过addTitleViewWithTitle创建的头 titleLabel 为标题

// tabBariItem
@property (nonatomic, strong) UIImage *itemNormalImage;
@property (nonatomic, strong) UIImage *itemSelectImage;

// navigationController
@property (nonatomic, strong) UINavigationController *currNavigationController;

/**
 设置 tabBarItem 的 value 显示

 @param value value
 @param index 索引值
 */
- (void)setBadgValue:(NSString *)value index:(NSInteger)index;


/**
 显示 tabBar
 */
- (void)showTabBar;

/**
 隐藏 tabbar
 */
- (void)hideTabBar;


/**
 显示 navigationBar
 */
- (void)showNavigationBar;

/**
 隐藏 navigationBar
 */
- (void)hideNavigationBar;

/**
    创建 navigationBar 的返回按钮
 */
- (UIButton *)makeBackButton;
- (void)backButtonClick:(UIButton *)sender;

- (UILabel *)makeTitleLabelWithTitle:(NSString *)title;


/**
 创建controller 的title 视图

 @param titleText title 文字

 @return 创建后的视图
 */
- (UIView *)addTitleViewWithTitle:(NSString *)titleText;


/**
 获取最顶部的 viewController

 @return 当前控制器的最顶层的 viewController
 */
- (UIViewController *)topViewController;

@end

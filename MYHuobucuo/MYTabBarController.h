//
//  MYTabBarController.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *keyMainViewController            = @"MY-MainViewController-Key";             // 首页
static NSString *keyProductCategoriesController   = @"MY-ProductCategoriesController-Key";    // 产品分类
static NSString *keyShoppingCarController         = @"MY-ShoppingCarController-Key";          // 购物车
static NSString *keyMineController                = @"MY-MineController-Key";                 // 我的
static NSString *keyPartnerController             = @"MY-PartnerController-Key";              // 合伙人
static NSString *keyExtensionController           = @"MY-ExtensionController-Key";            // 推广产品

typedef NS_ENUM(NSInteger) {
    MYTabBarVisibStyleDefault       = 0,       // 默认:首页/分类/购物车/我的
    MYTabBarVisibStyleMine          = 1,       // 当前页面是我的:商城首页/招募合伙人/推广产品/我的
    MYTabBarVisibStyleDistributor   = 2,       // 当前页面是招募,推广:商城首页/招募合伙人/推广产品/卖家中心
}MYTabBarVisibStyle;

@interface MYTabBarController : UITabBarController

@property (nonatomic, strong) NSArray *allChilControllersArray;

// 自定义 UI
@property (nonatomic, assign) CGFloat itemFontSize;             // items 的字体大小  ps:文字的大小必须在设置文字颜色之前,否则无效
@property (nonatomic, strong) UIColor *itemFontNormalColor;     // items 普通状态下的文字颜色
@property (nonatomic, strong) UIColor *itemFontSelectColor;     // items 选中状态下的文字颜色

+ (MYTabBarController *)sharedTabBarController;

/**
 根据类型改变 tabbarItem 的显示和对应的 viewController

 @param tabBarStyle tabBar的类型
 */
- (void)setTabBarVisibItem:(MYTabBarVisibStyle)tabBarStyle;

/**
 设定 tabbarItem 的 value

 @param value value 值
 @param index item 的索引值
 */
- (void)setTabBarItemValue:(NSString *)value index:(NSInteger)index;

@end

//
//  HDPageViewController.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDPageViewController;

@protocol HDPageViewControllerDelegate <NSObject>

@optional
- (void)pageViewController:(HDPageViewController *)pageController index:(NSInteger)index;

@end

@interface HDPageViewController : UIViewController

@property (nonatomic, strong) NSArray *titles;          // 标题数组
@property (nonatomic, strong) NSArray *controllers;     // 控制器数组

@property (nonatomic, assign) id<HDPageViewControllerDelegate> delegate;

// UI 定制
@property (nonatomic, strong) UIColor *currTitleColor;      // 当前title的颜色，默认红色
@property (nonatomic, strong) UIColor *normalTitleColor;    // 非当前title的颜色，默认黑色
@property (nonatomic, strong) UIColor *TitleLineColor;      // title底部线的颜色，默认红色
@property (nonatomic, assign) BOOL isShowTitleLine;         // 是否显示 title 的下划线

@property (nonatomic, strong) UIViewController *currController;// 当前的视图控制器
@property (nonatomic, copy) NSString *currTitle;    // 当前 title 的文字


/**
 *  初始化方法
 *
 *  @param frame        frame
 *  @param titles       标题数组
 *  @param controllers  控制器数组
 *
 *  @return             实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                  titleMargin:(CGFloat)titleMargin
                  titleHeight:(CGFloat)titleHeight
             firstTitleMargin:(CGFloat)firstMargin
                titleFontSize:(CGFloat)fontSize
                  controllers:(NSArray *)controllers;


/**
 获取 pageViewController 的 title 视图

 @return  titleView
 */
- (UIView *)getCurrentTitleView;

/**
 移动到指定的索引

 @param index 索引值
 */
- (void)moveToIndex:(NSInteger)index;

@end

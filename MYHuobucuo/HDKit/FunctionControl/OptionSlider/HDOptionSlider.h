//
//  HDOptionSlider.h
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  选项滑块控件
 */

#import <UIKit/UIKit.h>

@class HDOptionSlider;

typedef void (^DidSelectedBlock)(HDOptionSlider *optionSlider, NSInteger index);

@interface HDOptionSlider : UIView

@property (nonatomic, assign) NSInteger defaultIndex;               //控件显示默认选中的选项

@property (nonatomic, assign, readonly) NSInteger currentIndex;     //当前按钮索引值

@property (nonatomic, retain) NSArray *titlesArray;                 //所有控件的名称

@property (nonatomic, strong) UIColor *normalColor;                 //normal文字颜色

@property (nonatomic, strong) UIColor *selectedColor;               //selected文字颜色

@property (nonatomic, strong) UIColor *pointColor;                  //底部圆点颜色

@property (nonatomic, assign) NSInteger optionMargin;               //每个选项间间距

@property (nonatomic, assign) CGFloat fontSize;                     //显示字体大小

@property (nonatomic, assign) NSInteger pointRadius;                //底部圆点半径

@property (nonatomic, copy) DidSelectedBlock didSelectedBlock;

/**
 *  初始化一个按钮宽度自适应文字的实例
 *
 *  @param titles 包含按钮文字数组
 *
 *  @return       实例化的对象
 */
- (instancetype)initWithAutoButtonWithTitles:(NSArray *)titles;

/**
 *  初始化一个按钮宽度为固定值的实例
 *
 *  @param titles      包含按钮文字的数组
 *  @param buttonWidth 按钮的宽度
 *
 *  @return             实例化的对象
 */
- (instancetype)initWithConstantButtonWithTitles:(NSArray *)titles withButtonWidth:(NSInteger)buttonWidth;

/**
 *  移动到对应的选项
 *
 *  @param index        选项的索引值
 *  @param hasAnimation 移动过程是否有动画
 */
- (void)moveToButton:(NSInteger)index animation:(BOOL)hasAnimation;

@end

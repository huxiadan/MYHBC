//
//  HDTitleView.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

/**
    可滚动的titleView
 */

#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)(NSInteger index);

@interface HDTitleView : UIScrollView

@property (nonatomic, strong) UIColor *selectButtonColor;   // 选中的按钮显示的颜色，默认为红色
@property (nonatomic, strong) UIColor *normalButtonColor;   // 普通按钮显示的颜色，默认为黑色
@property (nonatomic, strong) UIColor *bottomLineColor;     // 底部横线的颜色，默认为红色
@property (nonatomic, assign) BOOL isShowBottomLine;        // 是否显示底部横线

@property (nonatomic, copy) ButtonClickBlock buttonClickBlock;  // 按钮点击的block

/**
 *  初始化
 *
 *  @param frame       frame
 *  @param titlesArray 标题的数组
 *
 *  @return 创建的实例
 */
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titlesArray
                 buttonMargin:(CGFloat)buttonMargin
            firstButtonMargin:(CGFloat)firstMargin
                     fontSize:(CGFloat)fontSize;

/**
 *  根据索引选中指定的按钮
 *
 *  @param buttonIndex 按钮的索引
 */
- (void)moveToButtonWithIndex:(NSInteger)buttonIndex;

@end

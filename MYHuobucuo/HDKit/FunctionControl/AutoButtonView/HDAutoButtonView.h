//
//  HDAutoButtonView.h
//  MYHuobucuo
//
//  Created by hudan on 16/9/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    自动根据按钮宽度换行的按钮集合视图
 */

#import <UIKit/UIKit.h>

#define HDAutoButtonViewFontSizeKey              @"HDAutoButtonViewFontSizeKey"                 // 文字大小
#define HDAutoButtonViewTitleColorKey            @"HDAutoButtonViewTitleColorKey"               // 文字颜色
#define HDAutoButtonViewTitleColorHeightLightKey @"HDAutoButtonViewTitleColorHeightLightKey"    // 文字的另一种颜色
#define HDAutoButtonViewCornerKey                @"HDAutoButtonViewCornerKey"                   // 按钮的圆角
#define HDAutoButtonViewBorderColorKey           @"HDAutoButtonViewBorderColorKey"              // 按钮边框的颜色
#define HDAutoButtonViewButtonMarginKey          @"HDAutoButtonViewButtonMarginKey"             // 按钮之间的最小间距

@interface HDAutoButtonView : UIView

/**
 初始化方法

 @param frame             farme
 @param titles            每个按钮的文字
 @param heightlightTitles 需要高亮现实的文字
 @param attribute         相关属性,见上面宏定义
 @param clickBlock        按钮点击的 block, 获取被点击按钮的 title

 @return 实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                 buttonTitles:(NSArray *)titles
            buttonTitleHeight:(NSArray *)heightlightTitles
          attributeDictionary:(NSDictionary *)attribute
                   clickBlock:(void(^)(NSString *))clickBlock;

@end

//
//  UITabBar+HD.h
//  Test
//
//  Created by hudan on 16/9/12.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (HD)


/**
 自定义 tabbar 中 item 的 UI

 @param index     item 的索引值
 @param number    item 显示的数字
 @param bgColor   item 的背景颜色
 @param textColor item 的文字颜色
 */
- (void)setBadgValueWithIndex:(NSInteger)index
                       number:(NSString *)number
              backgroundColor:(UIColor *)bgColor
                    textColor:(UIColor *)textColor;

@end

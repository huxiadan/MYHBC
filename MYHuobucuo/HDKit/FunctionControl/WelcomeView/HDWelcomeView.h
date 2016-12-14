//
//  HDWelcomeView.h
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  欢迎页 
 */

#import <UIKit/UIKit.h>

@interface HDWelcomeView : UIView

/**
 判断是否需要显示欢迎页

 @return YES: 没有显示过欢迎页  NO: 显示过欢迎页
 */
+ (BOOL)isNeedShowWelcomeView;

/**
 初始化方法

 @param imageArray  本地图片名称的数组
 @param pageControl 是否显示 pageControl
 @param enterButton 是否显示进入按钮
 @param jumpButton  是否显示跳过按钮

 @return 实例化的对象
 */
- (instancetype)initWithImagesArray:(NSArray *)imageArray
                    showPageControl:(BOOL)pageControl
                    showEnterButton:(BOOL)enterButton
                     showJumpButton:(BOOL)jumpButton;

@end

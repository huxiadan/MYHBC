//
//  UIView+HD.h
//  HDKit
//
//  Created by 1233go on 16/7/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HD)

/**
 *  根据起始点和结束点在DrawRect中画线
 *
 *  @param context 当前上下文
 *  @param bPoint  画线的起始点
 *  @param ePoint  画线的结束点
 */
- (void)drawLine:(CGContextRef)context beginPoint:(CGPoint)bPoint endPoint:(CGPoint)ePoint;

/**
 *  将视图转换成图片
 *
 *  @param view 需要转换的视图
 *
 *  @return 生成的图片
 */
+ (UIImage *)convertViewToImage:(UIView*)view;

@end

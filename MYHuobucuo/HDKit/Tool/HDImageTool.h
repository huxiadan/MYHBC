//
//  HDImageTool.h
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  图片处理类
 */

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface HDImageTool : NSObject

/**
 *  根据颜色生成纯色图片
 *
 *  @param color 图片的颜色
 *
 *  @return 纯色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  视图转换成图片
 *
 *  @param converView 需要转换的视图
 *
 *  @return 转换后的生成的图片
 */
+ (UIImage *)converViewToImage:(UIView *)converView;

/**
 *  将图片旋转至正常方向
 *
 *  @param image 需要旋转的图片
 *
 *  @return 旋转后的图片
 */
+ (UIImage *)fixImageOrientation:(UIImage *)image;


/**
 将图片生成高斯模糊图片

 @param image 图片
 @param blur 模糊指数
 @return 生成的图片
 */
+(UIImage *)makeBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end

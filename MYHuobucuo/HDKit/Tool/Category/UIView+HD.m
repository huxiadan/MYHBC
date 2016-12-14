//
//  UIView+HD.m
//  HDKit
//
//  Created by 1233go on 16/7/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "UIView+HD.h"

@implementation UIView (HD)

// 根据起始点和结束点在DrawRect中画线
- (void)drawLine:(CGContextRef)context beginPoint:(CGPoint)bPoint endPoint:(CGPoint)ePoint
{
    [[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1] set];
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, bPoint.x, bPoint.y);
    CGContextAddLineToPoint(context, ePoint.x, ePoint.y);
    CGContextStrokePath(context);
}

// 视图转换图片
+ (UIImage *)convertViewToImage:(UIView *)view
{
    CGSize s = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

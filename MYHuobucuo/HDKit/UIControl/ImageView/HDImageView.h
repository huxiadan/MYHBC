//
//  HDImageView.h
//  HDKit
//
//  Created by 胡丹 on 16/8/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDImageView : UIImageView

/**
 *  设置圆角图片（效率高于设置layer的cornerRadius属性）
 *
 *  @param image  imageView的image
 *  @param radius 圆角的半径
 */
- (void)setRadiusImage:(UIImage *)image radius:(CGFloat)radius;

@end

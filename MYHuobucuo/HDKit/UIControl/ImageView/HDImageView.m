//
//  HDImageView.m
//  HDKit
//
//  Created by 胡丹 on 16/8/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDImageView.h"

@implementation HDImageView

- (void)setRadiusImage:(UIImage *)image radius:(CGFloat)radius
{
    CGRect rect = (CGRect){0.f, 0.f, image.size};
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, UIScreen.mainScreen.scale);CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);CGContextClip(UIGraphicsGetCurrentContext());
    
    [image drawInRect:rect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.image = newImage;
}

@end

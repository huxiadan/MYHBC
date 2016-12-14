//
//  NSString+HD.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "NSString+HD.h"

@implementation NSString (HD)

- (CGSize)sizeForFontsize:(CGFloat)fontsize
{
    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]}];
    
//    size.width += 6;
    
    return size;
}

@end

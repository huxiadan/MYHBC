//
//  NSString+HD.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (HD)

/**
 *  计算当前string的大小
 *
 *  @param fontsize 显示的字体大小
 *
 *  @return 计算后的大小
 */
- (CGSize)sizeForFontsize:(CGFloat)fontsize;

@end

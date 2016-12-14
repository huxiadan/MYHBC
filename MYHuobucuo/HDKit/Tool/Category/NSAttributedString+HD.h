//
//  NSAttributedString+HD.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (HD)

/**
 *  根据给定的string和行间距生成一个attributeString
 *
 *  @param text 文字
 *  @param lineSpacing 行间距
 *
 *  @return 生成的 attributeString
 */
+ (NSAttributedString *)getAttributeString:(NSString *)text lineSpacing:(CGFloat)lineSpacing;

@end

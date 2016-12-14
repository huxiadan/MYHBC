//
//  NSAttributedString+HD.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "NSAttributedString+HD.h"

@implementation NSAttributedString (HD)

+ (NSAttributedString *)getAttributeString:(NSString *)text lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeAtring =[[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [attributeAtring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributeAtring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, [text length])];
    
    return attributeAtring;
}

@end

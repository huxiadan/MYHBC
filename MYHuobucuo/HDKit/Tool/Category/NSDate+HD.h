//
//  NSDate+HD.h
//  HDKit
//
//  Created by 胡丹 on 16/8/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (HD)

/**
 *  将date字符串按照给定的格式字符串进行格式化
 *
 *  @param dateString       需要格式化的时间字符串
 *  @param formatterString  格式化的字符串
 *
 *  @return                 格式化后的 NSDate 对象
 */
- (NSDate *)dateWithString:(NSString *)dateString formatterString:(NSString *)formatterString;

@end

//
//  NSDate+HD.m
//  HDKit
//
//  Created by 胡丹 on 16/8/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "NSDate+HD.h"
#import "ToolSingleton.h"

@implementation NSDate (HD)

- (NSDate *)dateWithString:(NSString *)dateString formatterString:(NSString *)formatterString
{
    fShareToolInstance.dateFormatter.dateFormat = formatterString;
    fShareToolInstance.dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    
    return [fShareToolInstance.dateFormatter dateFromString:dateString];
}

@end

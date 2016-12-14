//
//  HDDeviceInfo.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDDeviceInfo.h"

#import <UIKit/UIKit.h>

#import "CommHeader.h"

@implementation HDDeviceInfo

// 4.7寸屏幕为基准的适配比例
+ (float)screenMultipleIn6
{
//    if (kAppHeight == 667.0) {
//        return 1.0;
//    }
//    else if (kAppHeight <= 568.0)
//    {
//        return 568/667.0;
//    }
    return kAppHeight/667.0;
}

// 5.5寸屏幕为基准的适配比例
+ (float)screenMultipleIn6p
{
    if (kAppHeight==736.0)//小于iPhone5高度
    {
        return  1.0;
    }
    else if (kAppHeight<=568)
    {
        return 568/736.0;
    }
    
    return kAppHeight/736.0;
}

// 判断设备
+ (BOOL)isIPhone4Size
{
    return kAppHeight == 480.0 ? YES : NO;
}

+(BOOL)isIPhone5Size
{
    return kAppHeight == 568.0 ? YES : NO;
}

+(BOOL)isIPhone6Size
{
    return kAppHeight == 667.0 ? YES : NO;
}

+(BOOL)isIPhone6PSize
{
    return kAppHeight == 736.0 ? YES : NO;
}

// 调用电话功能拨打电话
+ (void)callPhoneWithPhoneNumber:(NSString *)phoneNumber
{
    if ([phoneNumber isEqualToString:@""]) {
        DLog(@"empty number string!");
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNumber];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

#pragma Getter

// 当前系统版本
- (NSInteger)currentOSVersion
{
    NSInteger version;
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (systemVersion >= 10.0) {
        version = 10;
    }
    else if (systemVersion >= 9.0) {
        version = 9;
    }
    else if (systemVersion >= 8.0) {
        version = 8;
    }
    else if (systemVersion >= 7.0) {
        version = 7;
    }
    else {
        version = 6;
    }
    
    return version;
}

@end

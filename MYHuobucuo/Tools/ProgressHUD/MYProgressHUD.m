//
//  MYProgressHUD.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/24.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "MYProgressHUD.h"

#import <SVProgressHUD.h>
#import "HDDeviceInfo.h"

@implementation MYProgressHUD

+ (void)showAlertWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showInfoWithStatus:message];
}

+ (void)showWhiteAlertWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.8f]];
    [SVProgressHUD setForegroundColor:[UIColor blackColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD showInfoWithStatus:message];
}

+ (void)showWaitingViewWithMessage:(NSString *)message
{
    if (message.length > 0) {
        message = @"请等待";
    }
    [SVProgressHUD showWithStatus:message];
}

+ (void)dismissMessageView
{
    [SVProgressHUD dismiss];
}

+ (void)showAlterWithMessage:(NSString *)message image:(UIImage *)image backgroundColor:(UIColor *)bgColor
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setInfoImage:image];
    [SVProgressHUD setBackgroundColor:bgColor];
    [SVProgressHUD showWithStatus:message];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

@end

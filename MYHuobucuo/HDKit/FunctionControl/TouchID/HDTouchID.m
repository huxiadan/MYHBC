//
//  HDTouchID.m
//  Test
//
//  Created by hudan on 16/9/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDTouchID.h"

#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface HDTouchID ()

@property (nonatomic, strong) LAContext *laContext;

@end

@implementation HDTouchID


- (BOOL)canUseTouchID
{
    //iOS8.0后才支持指纹识别接口
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return NO;
    }
    
    NSError *error = nil;
    NSString *result = @"请校验已有指纹";
    __block NSString *failReason = nil;
    BOOL success = NO;
    
    if ([self.laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        // 支持指纹验证
        
        [self.laContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                success = YES;
                
                if (self.touchSuccessBlock) {
                    self.touchSuccessBlock();
                }
            }
            else
            {
                success = NO;
                
                NSLog(@"%@",error.localizedDescription);
                switch (error.code) {
                    case LAErrorSystemCancel:
                    {
                        //系统取消授权，如其他APP切入
                        failReason = @"系统取消授权";
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        //用户取消验证Touch ID
                        failReason = @"用户取消验证Touch ID";
                        break;
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        //授权失败
                        failReason = @"授权失败";
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        //系统未设置密码
                        failReason = @"系统未设置密码";
                        break;
                    }
                    case LAErrorTouchIDNotAvailable:
                    {
                        //设备Touch ID不可用，例如未打开
                        failReason = @"设备Touch ID不可用";
                        break;
                    }
                    case LAErrorTouchIDNotEnrolled:
                    {
                        //设备Touch ID不可用，用户未录入
                        failReason = @"设备Touch ID不可用";
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //用户选择输入密码，切换主线程处理
                            
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            //其他情况，切换主线程处理
                        }];
                        break;
                    }
                }
            }
            
            if (failReason.length > 0) {
                if (self.touchFailBlock) {
                    self.touchFailBlock(failReason);
                }
            }
        }];
    }
    else {
        success = NO;
        
        // 不支持指纹验证
        //不支持指纹识别，LOG出错误详情
        NSLog(@"不支持指纹识别");
        
        switch (error.code) {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"%@",error.localizedDescription);
    }
    
    return success;
}

#pragma mark - Getter

- (LAContext *)laContext
{
    if (!_laContext) {
        _laContext = [[LAContext alloc] init];
    }
    return _laContext;
}

@end

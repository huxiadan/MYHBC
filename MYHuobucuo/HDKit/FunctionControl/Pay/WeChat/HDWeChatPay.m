//
//  HDWeChatPay.m
//  Test
//
//  Created by hudan on 16/9/19.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDWeChatPay.h"

#import "WXApiObject.h"

#import <UIKit/UIKit.h>
#import "MYProgressHUD.h"

#define WXPayURL @""

@interface HDWeChatPay () <WXApiDelegate>

@end

@implementation HDWeChatPay

+ (HDWeChatPay *)shareInstance
{
    static HDWeChatPay *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)registerApp:(NSString *)appID
{
    [WXApi registerApp:appID withDescription:@"货不错"];
}

- (void)payWithName:(NSString *)goodsName money:(NSString *)goodsMoney scnString:(NSString *)scnString
{
    // 判断是否安装客户端
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"信息提示" message:@"微信客户端未安装"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了" otherButtonTitles: nil, nil];
        [alertView show];
    }
    
    // 支付金额处理
    goodsMoney = [NSString stringWithFormat:@"%.2f",[goodsMoney floatValue]];
    
    // 显示请求微信中
    [MYProgressHUD showWaitingViewWithMessage:@"请求微信支付中..."];
    
    // 处理支付
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // 请求后台支付接口并传入参数
#warning URL需要在后台出来后再确定
        NSString *payURL = [NSString stringWithFormat:@"%@",WXPayURL];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:payURL]];
        
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (response) {
            NSError *error;
            
            NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
            
            if (dict) {
                NSMutableString *retcode = [dict objectForKey:@"retcode"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                    
                    //调起微信支付
                    PayReq* req             = [[PayReq alloc] init];
                    req.partnerId           = [dict objectForKey:@"partnerid"];
                    req.prepayId            = [dict objectForKey:@"prepayid"];
                    req.nonceStr            = [dict objectForKey:@"noncestr"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = [dict objectForKey:@"package"];
                    req.sign                = [dict objectForKey:@"sign"];
                    
                    [WXApi sendReq:req];
                    //日志输出
                    DLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                }
                else {
                    [strongSelf showAlertInfo:[NSString stringWithFormat:@"%@",[dict objectForKey:@"retmsg"]]];
                }
            }
            else {
                [strongSelf showAlertInfo:@"服务器返回错误,返回数据类型错误"];
            }
        }
        else {
            [strongSelf showAlertInfo:@"服务器返回错误,未成功返回数据"];
        }
    });
}

- (void)showAlertInfo:(NSString *)infoMessage
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付失败" message:infoMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - wxAPI delegate
- (void)onResp:(BaseResp *)resp
{
    [MYProgressHUD dismissMessageView];
    
    NSString *message = [NSString stringWithFormat:@"error:%@",resp.errStr];
    
    if ([resp isKindOfClass:[PayResp class]]) {
  
        switch (resp.errCode) {
            case WXSuccess:
                message = @"微信支付成功!";
                break;
            case WXErrCodeCommon:
                message = @"微信支付失败:普通错误类型.";
                break;
            case WXErrCodeUserCancel:
                message = @"你已取消微信支付!";
                break;
            case WXErrCodeSentFail:
                message = @"微信支付失败:发送支付请求失败.";
                break;
            case WXErrCodeAuthDeny:
                message = @"微信支付失败:微信授权失败.";
                break;
            case WXErrCodeUnsupport:
                message = @"微信支付失败:微信不支持.";
                break;
            default:
                message = @"微信支付失败:微信不支持.";
                break;
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"支付结果" message:message  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
    // 发送支付结果通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kWeChatPayFinishNotification object:[NSNumber numberWithBool:(resp.errStr == WXSuccess ? YES : NO)]];
}

@end

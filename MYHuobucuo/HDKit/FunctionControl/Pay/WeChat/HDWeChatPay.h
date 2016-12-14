//
//  HDWeChatPay.h
//  Test
//
//  Created by hudan on 16/9/19.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    微信支付封装
 */

#import <Foundation/Foundation.h>

#import "WXApi.h"

// 微信支付结果的通知 : 传递的参数:[类型: NSNumber] 支付成功:YES / 支付失败:NO
#define kWeChatPayFinishNotification @"kWeChatPayFinishNotification"

@interface HDWeChatPay : NSObject

+ (HDWeChatPay *)shareInstance;

- (void)registerApp:(NSString *)appID;

- (void)payWithName:(NSString *)goodsName money:(NSString *)goodsMoney scnString:(NSString *)scnString;

@end

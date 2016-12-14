//
//  HDAliPay.h
//  Huobucuo
//
//  Created by hudan on 16/9/20.
//  Copyright © 2016年 胡丹. All rights reserved.
//

/**
    支付宝支付封装
 */

#import <Foundation/Foundation.h>

#import <AlipaySDK/AlipaySDK.h>
#import "NetworkRequest.h"

#define AlipayAppScheme @""
#define AlipayDidFinishPayNotification @"AlipayDidFinishPayNotification"

@interface HDAliPay : NSObject

// 支付
- (void)aliPayWithOrderID:(NSString *)orderId payMoney:(NSString *)payMoney name:(NSString *)orderName
                   finish:(FinishBlock)finishBlock;

// 登录


@end

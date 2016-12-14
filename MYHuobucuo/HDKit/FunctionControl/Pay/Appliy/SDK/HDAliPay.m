//
//  HDAliPay.m
//  Huobucuo
//
//  Created by hudan on 16/9/20.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "HDAliPay.h"

#import "AliOrder.h"

@implementation HDAliPay

- (void)aliPayWithOrderID:(NSString *)orderId payMoney:(NSString *)payMoney name:(NSString *)orderName
                   finish:(FinishBlock)finishBlock
{
    // 支付宝校验
    [[NetworkRequest sharedNetworkRequest] aliPayCheckWithOrderID:orderId payMoney:payMoney name:orderName finish:^(id jsonData, NSError *error) {
        if (jsonData) {
            if ([jsonData isKindOfClass:[NSDictionary class]]) {
                NSDictionary *data = (NSDictionary *)jsonData;
                
                if ([data[@""] boolValue] == YES) {     // 判断状态是否正确
                    
                    // 获取签名订单字符串
                    NSString *orderString = data[@""];  // 获取 orderString
                    
                    if (orderString) {
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayAppScheme callback:^(NSDictionary *resultDic) {
                            
                            NSString *resultStatus = [NSString stringWithFormat:@"%@",[resultDic objectForKey:@"resultStatus"]];
                            BOOL payStatus = NO;
                            
                            if ([resultStatus rangeOfString:@"9000"].length > 0) {
                                // 支付成功
                                payStatus = YES;
                            }
                            else if ([resultStatus rangeOfString:@"6001"].length > 0) {
                                // 用户取消操作
                            }
                            else if ([resultStatus rangeOfString:@"8000"].length > 0) {
                                // 正在处理中
                            }
                            else if ([resultStatus rangeOfString:@"4000"].length > 0) {
                                // 订单支付失败
                            }
                            else if ([resultStatus rangeOfString:@"6002"].length > 0) {
                                // 网络连接失败
                            }
                            else {
                                // 订单支付失败
                            }
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:AlipayDidFinishPayNotification object:[NSNumber numberWithBool:payStatus]];
                        }];
                    }
                }
            }
        }
    }];
}

@end

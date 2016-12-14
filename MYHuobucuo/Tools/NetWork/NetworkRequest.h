//
//  NetworkRequest.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/24.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NetworkManager [NetworkRequest sharedNetworkRequest]

typedef void(^FinishBlock)(id jsonData, NSError *error);

@interface NetworkRequest : NSObject

// 单例
+ (NetworkRequest *)sharedNetworkRequest;

#pragma mark
#pragma mark - ShoppingCar
// 获取购物车数据
- (void)getShoppingCarInfo:(FinishBlock)finishBlock;

// 更新购物车商品的数量
- (void)updateGoodsNumber:(NSInteger)goodsNumber goodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock;

// 删除购物车中指定商品
- (void)deleteGoodsWithGoodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock;

// 清空购物车
- (void)deleteClearShoppingCar:(FinishBlock)finishBlock;


- (void)networkWithUrl:(NSString *)urlString postParametersDict:(NSDictionary *)parametersDict
           finishBlock:(FinishBlock)finishBlock;


#pragma mark
#pragma mark - User
// 登录
- (void)userLoginWithUserName:(NSString *)userName password:(NSString *)password finishBlock:(FinishBlock)finishBlock;

// 注册
- (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password checkCode:(NSString *)checkCode finishBlock:(FinishBlock)finishBlock;


#pragma mark 
#pragma mark - Pay
// 支付宝支付与服务器的校验
- (void)aliPayCheckWithOrderID:(NSString *)out_trade_no payMoney:(NSString *)payMoney name:(NSString *)name
                   finish:(FinishBlock)finishBlock;


@end

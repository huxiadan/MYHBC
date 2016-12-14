//
//  OrderDetailModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderShopModel.h"
#import "ShareModel.h"

@interface OrderDetailModel : NSObject

@property (nonatomic, copy) NSString *orderInfoTitle;   // 订单状态描述
@property (nonatomic, copy) NSString *orderSN;          // 订单编号
@property (nonatomic, copy) NSString *orderTime;        // 下单时间

@property (nonatomic, copy) NSString *payMoney;         // 支付金额
@property (nonatomic, copy) NSString *sendWay;          // 配送方式
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *buyer;            // 收货人
@property (nonatomic, strong) OrderShopModel *shopModel;// 订单的店铺对象

// 拼团
@property (nonatomic, assign) BOOL isGroup;             // 是否是拼团
@property (nonatomic, copy) NSString *note;             // 留言
@property (nonatomic, assign) NSUInteger numCount;      // 总数量
@property (nonatomic, assign) BOOL isGroupMasterFree;   // 是否是免单团团长
@property (nonatomic, strong) ShareModel *shareModel;

@end

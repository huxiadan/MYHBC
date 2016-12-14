//
//  PayOrderDetailController.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/6.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    支付---订单详情(商品详情/购物车结算时跳转)
 */

#import "BaseViewController.h"
#import "OrderShopModel.h"

@interface PayOrderDetailController : BaseViewController

- (instancetype)initWithPayArray:(NSArray<OrderShopModel *> *)payArray;

@end

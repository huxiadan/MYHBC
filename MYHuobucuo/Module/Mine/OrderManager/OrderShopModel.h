//
//  OrderShopModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/25.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    订单店铺模型
 */


#import <Foundation/Foundation.h>
#import "OrderModel.h"

@interface OrderShopModel : NSObject

@property (nonatomic, copy) NSString *shopId;           // 店铺 ID
@property (nonatomic, copy) NSString *shopName;         // 店铺名称
@property (nonatomic, assign) OrderShopState state;     // 店铺订单的状态
@property (nonatomic, assign) NSUInteger goodsCount;    // 商品总数量
@property (nonatomic, copy) NSString *goodsAmount;      // 商品总金额
@property (nonatomic, strong) NSArray<OrderModel *> *goodsArray;      // 店铺订单的商品列表, 数组元素是 OrderModel 对象

@property (nonatomic, assign) BOOL isSelect;            // 是否选中(购物车使用)
@property (nonatomic, assign) BOOL isEdit;              // 是否编辑(购物车使用)
@property (nonatomic, assign) BOOL isEditAll;           // 是否进入全部编辑(购物车使用)

- (void)setValueWithDict:(NSDictionary *)dict;

@end

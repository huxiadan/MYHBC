//
//  OrderShopModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/25.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "OrderShopModel.h"

@implementation OrderShopModel

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    for (OrderModel *model in self.goodsArray) {
        model.isEdit = isEdit;
    }
}

- (void)setIsEditAll:(BOOL)isEditAll
{
    _isEditAll = isEditAll;
    
    for (OrderModel *model in self.goodsArray) {
        model.isEditAll = isEditAll;
    }
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.shopId = [dict objectForKey:@"shop_id"];
    self.shopName = [dict objectForKey:@"shop_name"];
}

@end

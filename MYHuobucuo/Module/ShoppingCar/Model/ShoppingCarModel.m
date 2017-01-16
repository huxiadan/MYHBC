//
//  ShoppingCarModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShoppingCarModel.h"

@implementation ShoppingCarModel

- (void)setIsSelectAll:(BOOL)isSelectAll
{
    _isSelectAll = isSelectAll;
    
    if (self.shopArray.count > 0) {
        for (OrderShopModel *shop in self.shopArray) {
            shop.isSelect = isSelectAll;
            
            if (shop.goodsArray.count > 0) {
                for (OrderModel *goods in shop.goodsArray) {
                    goods.isSelect = isSelectAll;
                }
            }
        }
    }
}

- (void)setIsEditAll:(BOOL)isEditAll
{
    _isEditAll = isEditAll;
    
    for (OrderShopModel *model in self.shopArray) {
        model.isEditAll = isEditAll;
    }
}

- (void)setPayNumberCount:(NSUInteger)payNumberCount
{
    _payNumberCount = payNumberCount;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShoppingCarBuyNumberCountUpdateNoti object:nil];
}

@end

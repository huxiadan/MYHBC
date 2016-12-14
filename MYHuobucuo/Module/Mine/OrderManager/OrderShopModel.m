//
//  OrderShopModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/25.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "OrderShopModel.h"

@implementation OrderShopModel

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    
    for (OrderModel *model in self.goodsArray) {
        model.isSelect = isSelect;
    }
}

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

@end

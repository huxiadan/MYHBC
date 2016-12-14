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
    
    for (OrderShopModel *model in self.shopArray) {
        model.isSelect = isSelectAll;
    }
}

- (void)setIsEditAll:(BOOL)isEditAll
{
    _isEditAll = isEditAll;
    
    for (OrderShopModel *model in self.shopArray) {
        model.isEditAll = isEditAll;
    }
}

@end

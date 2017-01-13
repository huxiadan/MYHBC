//
//  MYSingleTon.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MYSingleTon.h"

@implementation MYSingleTon

SingletonM(MYSingleTon)

@synthesize currAdressModel = _currAdressModel;

#pragma mark - Setter
- (void)setCurrAdressModel:(AddressModel *)currAdressModel
{
    _currAdressModel = currAdressModel;
    
    [HDUserDefaults setObject:currAdressModel.receivePersonName forKey:cUserAddressName];
    [HDUserDefaults setObject:currAdressModel.phoneNumber forKey:cUserAddressPhone];
    [HDUserDefaults setObject:currAdressModel.province forKey:cUserAddressProvice];
    [HDUserDefaults setObject:currAdressModel.city forKey:cUserAddressCity];
    [HDUserDefaults setObject:currAdressModel.area forKey:cUserAddressArea];
    [HDUserDefaults setObject:currAdressModel.address forKey:cUserAddressAddress];
    [HDUserDefaults synchronize];
}

#pragma mark - Getter
- (AddressModel *)currAdressModel
{
    if (!_currAdressModel) {
        
        AddressModel *model = [[AddressModel alloc] init];
        model.receivePersonName = [HDUserDefaults objectForKey:cUserAddressName];
        model.phoneNumber       = [HDUserDefaults objectForKey:cUserAddressPhone];
        model.province          = [HDUserDefaults objectForKey:cUserAddressProvice];
        model.city              = [HDUserDefaults objectForKey:cUserAddressCity];
        model.area              = [HDUserDefaults objectForKey:cUserAddressArea];
        model.address           = [HDUserDefaults objectForKey:cUserAddressAddress];
        
        _currAdressModel = model;
    }
    return _currAdressModel;
}

#pragma mark - Public

- (void)updateShoppingCarDataWithSection:(NSUInteger)session actionSender:(NSInteger)actionSender
{
    if (!self.shoppingCarModel) {
        return;
    }
    
    OrderShopModel *shop = [self.shoppingCarModel.shopArray objectAtIndex:session];
    NSArray *goodsArray = shop.goodsArray;
    
    if (actionSender == 0) {
        // 点击店铺的选择按钮
        for (OrderModel *goods in goodsArray) {
            goods.isSelect = shop.isSelect;
        }
    }
    else if (actionSender == 1) {
        // 点击商品的选择按钮
        BOOL shopIsSelected = YES;
        
        for (OrderModel *goods in goodsArray) {
            if (goods.isSelect == NO) {
                shopIsSelected = NO;
                break;
            }
        }
    }
    
    if (shop.isSelect == NO) {
        self.shoppingCarModel.isSelectAll = NO;
    }
}



@end

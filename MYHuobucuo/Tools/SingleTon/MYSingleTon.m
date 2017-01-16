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

// 更新购物车数据模型的操作
- (void)updateShoppingCarDataWithSection:(NSUInteger)session row:(NSUInteger)row actionSender:(NSInteger)actionSender
{
    if (!self.shoppingCarModel) {
        return;
    }
    
    // 总数计算
    NSUInteger goodsCount = self.shoppingCarModel.payNumberCount;
    // 总价计算
    CGFloat moneyCount = [self.shoppingCarModel.payMoneyCount floatValue];
    
    OrderShopModel *shop = [self.shoppingCarModel.shopArray objectAtIndex:session];
    NSArray *goodsArray = shop.goodsArray;
    
    if (actionSender == 0) {
        // 点击店铺的选择按钮
        for (OrderModel *goods in goodsArray) {
            
            if (shop.isSelect == YES) {
                
                if (goods.isSelect != shop.isSelect) {
                    
                    goods.isSelect = shop.isSelect;
                    
                    goodsCount += goods.goodsNumber;
                    moneyCount += goods.goodsNumber * [goods.goodsPrice floatValue];
                }
            }
            else {
                if (goods.isSelect != shop.isSelect) {
                    
                    goods.isSelect = shop.isSelect;
                    
                    goodsCount -= goods.goodsNumber;
                    moneyCount -= goods.goodsNumber * [goods.goodsPrice floatValue];
                }
            }
        }
    }
    else if (actionSender == 1) {
        // 点击商品的选择按钮
        
        // 记录店铺是否要被选中
        BOOL shopIsSelected = YES;
        
        for (OrderModel *goods in goodsArray) {
            if (goods.isSelect == NO) {
                shopIsSelected = NO;
                break;
            }
        }
        
        OrderModel *goods = [shop.goodsArray objectAtIndex:row];
        
        if (goods.isSelect) {
            
            goodsCount += goods.goodsNumber;
            moneyCount += goods.goodsNumber * [goods.goodsPrice floatValue];
        }
        else {
            
            goodsCount -= goods.goodsNumber;
            moneyCount -= goods.goodsNumber * [goods.goodsPrice floatValue];
        }
        
        shop.isSelect = shopIsSelected;
    }
    else if (actionSender == 2) {
        // 全选
        if (self.shoppingCarModel.shopArray.count > 0) {
            
            for (OrderShopModel *eachShop in self.shoppingCarModel.shopArray) {
                
                if (eachShop.goodsArray.count > 0) {
                    
                    for (OrderModel *eachGoods in eachShop.goodsArray) {
                        if (self.shoppingCarModel.isSelectAll) {
                            // 全选
                            goodsCount += eachGoods.goodsNumber;
                            moneyCount += eachGoods.goodsNumber * [eachGoods.goodsPrice floatValue];
                        }
                        else {
                            // 全不选
                            goodsCount = 0;
                            moneyCount = 0;
                        }
                    }
                }
            }
        }
    }
    
    self.shoppingCarModel.payMoneyCount = [NSString stringWithFormat:@"%.2f",moneyCount];
    self.shoppingCarModel.payNumberCount = goodsCount;
}



@end

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

@end

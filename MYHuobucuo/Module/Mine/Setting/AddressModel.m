//
//  AddressModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.receivePersonName = dict[@"shipping_name"];
    self.phoneNumber = dict[@"telephone"];
    self.isDefaultAddress = [dict[@"isdefault"] boolValue];
    
    self.addressId = dict[@"address_id"];
    self.province = dict[@"zone"];
    self.city = dict[@"city"];
    self.area = dict[@"district"];
    self.address = dict[@"address"];
    self.postCode = dict[@"postcode"];
    
    self.provinceId = dict[@"zone_id"];
    self.cityId = dict[@"city_id"];
    self.areaId = dict[@"district_id"];
}

@end

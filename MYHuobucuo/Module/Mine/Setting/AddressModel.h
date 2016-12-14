//
//  AddressModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    地址 model
 */

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *receivePersonName;    // 收货人姓名
@property (nonatomic, copy) NSString *phoneNumber;          // 联系电话
@property (nonatomic, assign) BOOL isDefaultAddress;        // 是否默认地址

@property (nonatomic, copy) NSString *province;             // 省份
@property (nonatomic, copy) NSString *city;                 // 城市
@property (nonatomic, copy) NSString *area;                 // 地区
@property (nonatomic, copy) NSString *address;              // 详细地址

@end

//
//  MYSingleTon.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    暂存数据的单例
 */

#import <Foundation/Foundation.h>
#import "Singleton.h"

#import "AddressModel.h"
#import "ShoppingCarModel.h"

@interface MYSingleTon : NSObject

SingletonH(MYSingleTon)

@property (nonatomic, strong) NSArray<AddressModel *> *addressModelArray;   // 地址模型数组

@property (nonatomic, strong) ShoppingCarModel *shoppingCarModel; // 购物车数组

@end

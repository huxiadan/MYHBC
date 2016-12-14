//
//  ShoppingCarModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    购物车模型
 */

#import <Foundation/Foundation.h>
#import "OrderShopModel.h"

@interface ShoppingCarModel : NSObject

@property (nonatomic, assign) NSUInteger payNumberCount;            // 共计
@property (nonatomic, copy) NSString *payMoneyCount;                // 总价
@property (nonatomic, assign) BOOL isSelectAll;                     // 是否全选

@property (nonatomic, strong) NSArray<OrderShopModel *> *shopArray; // 购物车商店数组
@property (nonatomic, assign) BOOL isEditAll;                       // 是否编辑全部

@end

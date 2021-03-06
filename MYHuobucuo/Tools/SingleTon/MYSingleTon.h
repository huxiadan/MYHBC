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
@property (nonatomic, strong) AddressModel *currAdressModel;                // 当前的地址
@property (nonatomic, assign) BOOL isNeedUpdateAddress;                     // 用于判断重新选择地址后,返回conteoller 在 viewDidAppear 判断是否更新地址

@property (nonatomic, strong) ShoppingCarModel *shoppingCarModel; // 购物车数组

@property (nonatomic, strong) NSArray *goodsSelectSpecArray;    // 商品详情已选规格数组
@property (nonatomic, assign) NSUInteger goodsSpecMaxCount;     // 商品详情已选规格的最大数量


/**
 更新购物车数据模型的操作

 @param session 商品所在的 section
 @param actionSender  动作类型(0:点击 cell 头的店铺选择/ 1:点击 cell 商品的选择)
 */
- (void)updateShoppingCarDataWithSection:(NSUInteger)session row:(NSUInteger)row actionSender:(NSInteger)actionSender;

@end

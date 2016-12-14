//
//  OrderModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    订单商品模型
 */

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, copy) NSString *goodsId;              // 商品 id
@property (nonatomic, copy) NSString *goodsImageURL;        // 商品图片 URL 地址
@property (nonatomic, copy) NSString *goodsName;            // 商品名
@property (nonatomic, copy) NSString *goodsSpecification;   // 商品规格
@property (nonatomic, copy) NSString *goodsPrice;           // 商品单价
@property (nonatomic, assign) NSUInteger goodsNumber;       // 商品数量
@property (nonatomic, assign) NSUInteger goodsLimitNumber;  // 商品限购数量

@property (nonatomic, assign) BOOL isSelect;                // 是否选中(购物车中使用)
@property (nonatomic, assign) BOOL isEdit;                  // 是否编辑状态(购物车中使用)
@property (nonatomic, assign) BOOL isEditAll;               // 是否是所有 cell 进入编辑状态

@property (nonatomic, assign) NSUInteger maxNumber;         // 最大数量

@property (nonatomic, assign) BOOL isGroup;                 // 是否是拼团
@property (nonatomic, copy) NSString *groupId;              // 拼团的 id
@property (nonatomic, copy) NSString *groupInfoTitle;       // 拼团详情的 title

@end

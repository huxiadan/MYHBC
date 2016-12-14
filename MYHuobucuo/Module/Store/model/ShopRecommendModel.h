//
//  ShopRecommendModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店长推荐模型
 */

#import <Foundation/Foundation.h>

@interface ShopRecommendModel : NSObject

@property (nonatomic, copy) NSString *goodsId;          // 商品 id
@property (nonatomic, copy) NSString *goodsImageURL;    // 图片
@property (nonatomic, copy) NSString *goodsPrice;       // 价格
@property (nonatomic, assign) NSUInteger saleNumber;    // 销量

@end

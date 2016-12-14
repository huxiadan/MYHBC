//
//  GoodsDetailCollHeaderView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/16.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品详情-商品 collectionView 的 header (普通商品)
 */

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

static NSString *collHeaderViewIdentity = @"GoodsDetailCollHeaderViewIdentity";

typedef void(^GoodsSpecSelectBlock)();
typedef void(^GoodsToShopBlock)(NSString *shopId);
typedef void(^GoodsToEvaluteBlock)();

@interface GoodsDetailCollHeaderView : UICollectionReusableView

@property (nonatomic, strong) GoodsDetailModel *goodsModel;

@property (nonatomic, copy) GoodsSpecSelectBlock specSelectBlock;       // 规格点击
@property (nonatomic, copy) GoodsToShopBlock toShopBlock;               // 店铺点击
@property (nonatomic, copy) GoodsToEvaluteBlock toEvaluteBlock;         // 查看全部评价点击

@end

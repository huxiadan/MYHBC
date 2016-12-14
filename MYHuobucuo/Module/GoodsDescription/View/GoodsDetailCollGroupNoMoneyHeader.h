//
//  GoodsDetailCollGroupNoMoneyHeader.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品详情-商品 collectionView 的 header (拼团商品--免单团/秒杀团)
 */

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

static NSString *collNoMoneyHeaderViewIdentity = @"GoodsDetailCollGroupNoMoneyHeaderViewIdentity";

typedef void(^GoodsToShopBlock)(NSString *shopId);
typedef void(^GoodsToEvaluteBlock)();
typedef void(^JoinButtonClickBlock)();

@interface GoodsDetailCollGroupNoMoneyHeader : UICollectionReusableView

@property (nonatomic, strong) GoodsDetailModel *goodsModel;

@property (nonatomic, copy) GoodsToShopBlock toShopBlock;               // 店铺点击
@property (nonatomic, copy) GoodsToEvaluteBlock toEvaluteBlock;         // 查看全部评价点击
@property (nonatomic, copy) JoinButtonClickBlock joinBlock;             // 促销参加点击

@property (nonatomic, strong) UINavigationController *navigationController;

- (void)endTimer;

@end

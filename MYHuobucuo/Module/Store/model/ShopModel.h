//
//  ShopModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺模型
 */

#import <Foundation/Foundation.h>
#import "ShareModel.h"
#import "BaiXianBaiPinModel.h"
#import "GoodsModel.h"
#import "ShopRecommendModel.h"
#import "CollShopModel.h"
#import "BannerModel.h"

@interface ShopModel : NSObject

@property (nonatomic, copy) NSString *shopId;           // 店铺 id
@property (nonatomic, copy) NSString *shopName;         // 店铺名称
@property (nonatomic, copy) NSString *shopIconURL;      // 店铺图片
@property (nonatomic, assign) BOOL isCollected;         // 是否已收藏(登录用户)
@property (nonatomic, strong) ShareModel *shareModel;   // 分享
@property (nonatomic, assign) ShopIconType iconType;    // 店铺类型
@property (nonatomic, copy) NSString *notice;           // 公告

@property (nonatomic, strong) NSArray<BannerModel *> *bannerArray;            // 轮播图

@property (nonatomic, strong) NSArray<BaiXianBaiPinModel *> *groupArray;      // 拼团
@property (nonatomic, strong) NSArray<ShopRecommendModel *> *recommendArray;  // 店长推荐
@property (nonatomic, strong) NSArray<GoodsModel *> *hotArray;                // 热门推荐

@end

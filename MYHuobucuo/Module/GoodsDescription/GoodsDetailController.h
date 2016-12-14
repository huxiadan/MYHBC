//
//  GoodsDetailController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/14.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品详情-商品
 */

#import "BaseViewController.h"

typedef void(^GoodsDetailToEvaBlock)();
typedef void(^GoodsDetailShareBlock)();

@class GoodsDetailModel;

@interface GoodsDetailController : BaseViewController

@property (nonatomic, copy) GoodsDetailToEvaBlock toEvaBlock;
@property (nonatomic, copy) GoodsDetailShareBlock shareBlock;

- (instancetype)initWithGoodsModel:(GoodsDetailModel *)goodsModel bottomView:(UIView *)bottomView;

@end

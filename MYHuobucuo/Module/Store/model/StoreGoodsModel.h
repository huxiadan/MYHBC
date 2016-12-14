//
//  StoreGoodsModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoodsModel.h"
#import "ShareModel.h"

@interface StoreGoodsModel : GoodsModel

@property (nonatomic, assign) BOOL collected;               // 收藏
@property (nonatomic, assign) BOOL groupBuy;                // 团购
@property (nonatomic, strong) ShareModel *shareModel;       // 分享

@end

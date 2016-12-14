//
//  StoreGoodsCollCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"

typedef void(^AddShoppingCarButtonClickBlock)(GoodsModel *goodsModel);

static NSString *collidentity = @"StoreGoodsCollCellIdentity";

@interface StoreGoodsCollCell : UICollectionViewCell

@property (nonatomic, strong) StoreGoodsModel *goodsModel;

@property (nonatomic, strong) AddShoppingCarButtonClickBlock addShoppingCarBlock;

@end

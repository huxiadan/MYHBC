//
//  CategoryDetailCollCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

typedef void(^AddShoppingCarButtonClickBlock)(GoodsModel *goodsModel);

static NSString *collidentity = @"CategoryDetailCollCellIdentity";

@interface CategoryDetailCollCell : UICollectionViewCell

@property (nonatomic, strong) GoodsModel *goodsModel;

@property (nonatomic, strong) AddShoppingCarButtonClickBlock addShoppingCarBlock;

@end

//
//  StoreGoodsTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺---商品-- tableView Cell
 */

#import <UIKit/UIKit.h>
#import "StoreGoodsModel.h"

static NSString *tabCellIdentity = @"StoreGoodsTabCellIdentity";
#define kStoreGoodsTabCellRowHeight fScreen(240) + 2

typedef void(^CollectionButtonClickBlock)(BOOL isCollection);
typedef void(^ShareButtonClickBlock)(ShareModel *shareModel);

@interface StoreGoodsTabCell : UITableViewCell

@property (nonatomic, strong) StoreGoodsModel *model;
@property (nonatomic, copy) CollectionButtonClickBlock collectBlock;
@property (nonatomic, copy) ShareButtonClickBlock shareBlock;

@end

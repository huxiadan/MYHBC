//
//  ShopMasterRecommView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺首页 店长推荐视图
 */

#import <UIKit/UIKit.h>
#import "ShopRecommendModel.h"

typedef void(^ShopMasterRecommViewClickBlock)(NSString *goodsId);

@interface ShopMasterRecommView : UIView

@property (nonatomic, copy) ShopMasterRecommViewClickBlock clickBlock;

- (instancetype)initWithRecommendArray:(NSArray *)array;

@end


#pragma mark
#pragma mark - ShopMasterRecommViewCollCell

static NSString *ShopMasterRecommViewCollCellIdentity = @"ShopMasterRecommViewCollCellIdentity";

@interface ShopMasterRecommViewCollCell : UICollectionViewCell

@property (nonatomic, strong) ShopRecommendModel *model;

@end

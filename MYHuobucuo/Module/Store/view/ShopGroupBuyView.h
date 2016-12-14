//
//  ShopGroupBuyView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺首页拼团
 */

#import <UIKit/UIKit.h>

typedef void(^ShopGroupBuyViewCellClickBlock)(NSString *goodsId);

@interface ShopGroupBuyView : UIView

@property (nonatomic, copy) ShopGroupBuyViewCellClickBlock clickBlock;

- (instancetype)initWithGroupArray:(NSArray *)groupArray;

@end

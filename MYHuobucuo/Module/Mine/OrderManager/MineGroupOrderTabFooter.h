//
//  MineGroupOrderTabFooter.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    拼团订单列表的 footerView
 */

#import <UIKit/UIKit.h>
#import "OrderShopModel.h"

#define kMineOrderTabFooterHeight fScreen(68 + 2 + 78 - 10) // 减10是因为 cell 底部还有10的白色边

typedef void(^LeftButtonClickBlock)(OrderShopState state);
typedef void(^RightButtonClickBlock)(OrderShopState state);

@interface MineGroupOrderTabFooter : UIView

@property (nonatomic, strong) OrderShopModel *orderShopModel;

@property (nonatomic, copy) LeftButtonClickBlock leftButtonBlock;
@property (nonatomic, copy) RightButtonClickBlock rightButtonBlock;

@end

//
//  ShoppingCarHeaderView.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderShopModel.h"

#define kShoppingCarHeaderViewHeight fScreen(88 + 20)

typedef void(^SelectAllButtonClickBlock)();
typedef void(^EditButtonClickBlock)();
typedef void(^StoreNameClickBlock)(NSString *shopId);

@interface ShoppingCarHeaderView : UIView

@property (nonatomic, strong) OrderShopModel *shopModel;

@property (nonatomic, copy) SelectAllButtonClickBlock selectAllBlock;   // 店铺全选按钮点击
@property (nonatomic, copy) EditButtonClickBlock editBlock;             // 编辑按钮点击
@property (nonatomic, copy) StoreNameClickBlock storeBlock;             // 店铺名点击

@end

//
//  StoreGoodsController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺---商品
 */

#import "StoreModuleBaseViewController.h"

typedef void(^StoreSubDidScroll)();

@interface StoreGoodsViewController : StoreModuleBaseViewController

@property (nonatomic, copy) NSString *categoryString;           // 分类的字段(从分类跳转过来使用)

@property (nonatomic, copy) StoreSubDidScroll scrollBlock;      // 滚动中的 block

- (instancetype)initWithShopId:(NSString *)shopId mainView:(UIView *)mainView;

// 集合视图可滚动
- (void)setCanScroll;
// 集合视图不可滚动
- (void)setCanNotScroll;

@end

//
//  StoreCategoryViewController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺---分类
 */

#import "StoreModuleBaseViewController.h"

typedef void(^StoreSubDidScroll)();

@interface StoreCategoryViewController : StoreModuleBaseViewController

@property (nonatomic, copy) StoreSubDidScroll scrollBlock;      // 滚动中的 block

- (instancetype)initWithShopId:(NSString *)shopId;

- (void)setCanScroll;
- (void)setCanNotScroll;

@end

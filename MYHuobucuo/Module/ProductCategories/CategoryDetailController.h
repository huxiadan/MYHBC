//
//  CategoryDetailController.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品分类详细
 */

#import "BaseViewController.h"

@class CategoryDetailModel;

@interface CategoryDetailController : BaseViewController

- (instancetype)initWithTitle:(NSString *)controllerTitle categoryArray:(NSArray<CategoryDetailModel *> *)categoryArray index:(NSInteger)index;

@end

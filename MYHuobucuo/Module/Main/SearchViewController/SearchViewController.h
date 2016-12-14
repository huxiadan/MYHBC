//
//  SearchViewController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    搜索界面
 */

#import "BaseViewController.h"

@interface SearchViewController : BaseViewController

/**
 初始化,如果是店铺内的搜索,传入店铺 id

 @param shopId  店铺 id
 @return  对象
 */
- (instancetype)initWithShopId:(NSString *)shopId;

@end

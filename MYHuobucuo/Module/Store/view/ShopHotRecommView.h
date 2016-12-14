//
//  ShopHotRecommView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺首页 热门推荐视图
 */

#import <UIKit/UIKit.h>

typedef void(^ShopHotRecommViewClickBlock)(NSString *goodsId);

@interface ShopHotRecommView : UIView

@property (nonatomic, copy) ShopHotRecommViewClickBlock clickBlock;

- (instancetype)initWithHotArray:(NSArray *)array;

@end

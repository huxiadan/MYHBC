//
//  GoodsSpecSelectView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/18.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品详情--规格选择界面
 */

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

@class GoodsSpecOptionButton;

typedef void(^SelectSpecBlock)(NSArray<GoodsSpecOptionButton *> *selectButtonArray, NSString *price, NSUInteger quantity); // 数组为规格的 id

@interface GoodsSpecSelectView : UIView

@property (nonatomic, strong) SelectSpecBlock selectSpecBlock;

- (instancetype)initWithGoodsDetailModel:(GoodsDetailModel *)model;

- (void)hideView;
- (void)showView;

@end


@interface GoodsSpecOptionButton : UIButton

@property (nonatomic, assign) NSInteger groupIndex;
@property (nonatomic, copy) NSString *specId;

@end

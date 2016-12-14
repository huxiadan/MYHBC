//
//  GoodsDetailBottomView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ServiceButtonClickBlock)();
typedef void(^ToShopButtonClickBlock)();
typedef void(^CollectButtonClickBlock)();
typedef void(^AddToShopCarButtonClickBlock)();
typedef void(^PayButtonClickBlock)();

@interface GoodsDetailBottomView : UIView

@property (nonatomic, copy) ServiceButtonClickBlock serviceBlock;
@property (nonatomic, copy) ToShopButtonClickBlock toShopBlock;
@property (nonatomic, copy) CollectButtonClickBlock collectBlock;
@property (nonatomic, copy) AddToShopCarButtonClickBlock addShopCarBlock;
@property (nonatomic, copy) PayButtonClickBlock payBlock;

@end

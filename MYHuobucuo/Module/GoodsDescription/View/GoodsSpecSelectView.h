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

typedef void(^SelectSpecBlock)(NSArray *specArray);

@interface GoodsSpecSelectView : UIView

@property (nonatomic, strong) SelectSpecBlock selectSpecBlock;

// 根据规格数组初始化
- (instancetype)initWithSpecArray:(NSArray *)specArray;

- (void)hideView;
- (void)showView;

@end

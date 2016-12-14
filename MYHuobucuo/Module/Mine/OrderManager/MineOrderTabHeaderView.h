//
//  MineOrderTabHeaderView.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMineOrderTabHeaderHeight fScreen(68 + 20)

@class OrderShopModel;
@interface MineOrderTabHeaderView : UIView

@property (nonatomic, strong) OrderShopModel *orderShopModel;

@end

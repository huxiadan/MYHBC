//
//  ShoppingCarTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

#define kShoppingCarTabCellHeight fScreen(200)

typedef void(^SelectButtonClickBlock)(OrderModel *model);
typedef void(^DeleteButtonClickBlock)(OrderModel *model);

@interface ShoppingCarTabCell : UITableViewCell

@property (nonatomic, strong) OrderModel *orderModel;
@property (nonatomic, copy) SelectButtonClickBlock selectBlock;
@property (nonatomic, copy) DeleteButtonClickBlock deleteBlock;

@end

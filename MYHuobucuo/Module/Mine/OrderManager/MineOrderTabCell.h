//
//  MineOrderTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *cellIdentity = @"orderManagerListCellIdentity";

#define kMineOrderTabCellHeight fScreen(20 + 160 + 20 + 10)

@class OrderModel;
@interface MineOrderTabCell : UITableViewCell

@property (nonatomic, strong) OrderModel *orderModel;

@end

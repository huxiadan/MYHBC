//
//  GroupBuyLimitTimeTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    千县拼团 -- 秒杀 cell
 */

#import "GroupbuyBaseTabCell.h"

static NSString *groupbuyLimitCellIdentity = @"GroupBuyLimitTimeTabCellIdentity";

@interface GroupBuyLimitTimeTabCell : GroupbuyBaseTabCell

@property (nonatomic, strong) BaiXianBaiPinModel *model;

@property (nonatomic, assign) NSUInteger time;

@end

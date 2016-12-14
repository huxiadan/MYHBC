//
//  BaiXianBaiPinLimitTimeTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    百县百品 --- 限制时间
 */

#import "BaiXianBaiPinBaseTabCell.h"

static NSString *BaiXianBaiPinLimitTimeTabCellIdentity = @"BaiXianBaiPinLimitTimeTabCellIdentity";

@interface BaiXianBaiPinLimitTimeTabCell : BaiXianBaiPinBaseTabCell

@property (nonatomic, strong) BaiXianBaiPinModel *model;

@property (nonatomic, assign) NSUInteger time;

@end

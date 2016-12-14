//
//  GroupbuyOrderHeaderView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    团购订单的 header
 */

#import <UIKit/UIKit.h>
#import "GroupbuyOrderModel.h"

typedef void(^PickUpButtonClickBlock)(BOOL isPickUp, CGFloat listViewHeight);

@interface GroupbuyOrderHeaderView : UIView

@property (nonatomic, assign, readonly) CGFloat height;

- (instancetype)initWithModel:(GroupbuyOrderModel *)model;

@property (nonatomic, copy) PickUpButtonClickBlock pickUpBlock;

@property (nonatomic, strong) NSTimer *timer;

@end

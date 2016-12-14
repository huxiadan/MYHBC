//
//  PayViewController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/18.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    支付
 */

#import "BaseViewController.h"

@interface PayViewController : BaseViewController

- (instancetype)initWithOrderNo:(NSString *)orderNo payMoney:(NSString *)payMoney;

@end

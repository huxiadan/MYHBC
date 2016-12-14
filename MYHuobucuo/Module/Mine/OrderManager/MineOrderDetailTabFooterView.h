//
//  MineOrderDetailTabFooterView.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/25.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    订单详情的 footerView
 */

#import <UIKit/UIKit.h>

@interface MineOrderDetailTabFooterView : UIView

@property (nonatomic, copy) NSString *payMoney;         // 合计金额
@property (nonatomic, copy) NSString *userNoteString;   // 留言

@end

//
//  MineGroupOrderDetailTabFooterView.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/12.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    免单团团长的订单详情的 footerView
 */

#import <UIKit/UIKit.h>

@interface MineGroupOrderDetailTabFooterView : UIView

- (instancetype)initWithNote:(NSString *)note
                       count:(NSUInteger)count
                         pay:(NSString *)pay
                     isMster:(BOOL)isMaster;

@end

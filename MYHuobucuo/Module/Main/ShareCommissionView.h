//
//  ShareCommissionView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    包含佣金字段的分享
 */

#import <UIKit/UIKit.h>
#import "ShareModel.h"

@interface ShareCommissionView : UIView

- (instancetype)initWithCommissionText:(NSString *)commissionText;

@property (nonatomic, strong) ShareModel *shareModel;
@property (nonatomic, strong) UINavigationController *currNaviController;

@end

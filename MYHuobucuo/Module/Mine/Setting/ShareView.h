//
//  CollectShareView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    收藏的商品分享界面
 */

#import <UIKit/UIKit.h>
#import "ShareModel.h"

@interface ShareView : UIView

@property (nonatomic, strong) ShareModel *shareModel;
@property (nonatomic, strong) UINavigationController *currNaviController;   // 用于短信界面跳转

@end

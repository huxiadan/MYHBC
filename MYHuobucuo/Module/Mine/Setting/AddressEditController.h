//
//  AddressEditController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    收货地址编辑界面(修改/添加)
 */

#import "BaseViewController.h"
#import "AddressModel.h"

@interface AddressEditController : BaseViewController

- (instancetype)initWithModel:(AddressModel *)model;

@end

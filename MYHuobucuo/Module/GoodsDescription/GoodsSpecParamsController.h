//
//  GoodsSpecParamsController.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品详情--详情--规格参数
 */

#import "BaseViewController.h"

@interface GoodsSpecParamsController : BaseViewController

@property (nonatomic, strong) NSArray *textArray;

@end


@interface GoodsSpecParamsModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) CGFloat rowHeight;

@end

@interface GoodsSpecParamsTabCell : UITableViewCell

@property (nonatomic, strong) GoodsSpecParamsModel *model;

@end


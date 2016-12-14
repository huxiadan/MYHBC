//
//  CollGoodsModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"

@interface CollGoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *goodsImageURL;
@property (nonatomic, copy) NSString *goodsPrice;
@property (nonatomic, assign) BOOL isInvalid;

// 分享
@property (nonatomic, strong) ShareModel *shareModel;

@property (nonatomic, assign) BOOL isSelected;      // 用于管理是否被选中进行批量处理
@property (nonatomic, assign) BOOL isEdit;          // 是否进入编辑状态

@end

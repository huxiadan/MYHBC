//
//  BaiXianBaiPinModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    百县百品数据模型
 */

#import <Foundation/Foundation.h>

@interface BaiXianBaiPinModel : NSObject

@property (nonatomic, copy) NSString *goodsId;                  // 商品 id
@property (nonatomic, copy) NSString *goodsImageUrl;            // 商品图片地址
@property (nonatomic, copy) NSString *goodsName;                // 商品名
@property (nonatomic, copy) NSString *goodsSpec;                // 商品规格
@property (nonatomic, copy) NSString *price;                    // 商品价格
@property (nonatomic, copy) NSString *marketPrice;              // 商品原价
@property (nonatomic, assign) NSUInteger personCount;           // 成团人数
@property (nonatomic, assign) BaiXianBaiPinCellType type;       // 类型

// 佣金
@property (nonatomic, copy) NSString *commissionTitle;          // 佣金标题
@property (nonatomic, copy) NSString *commissionContent;        // 佣金金额

// 倒计时
@property (nonatomic, assign) NSUInteger countDownTime;            // 倒计时

@end

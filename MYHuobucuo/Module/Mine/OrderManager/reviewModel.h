//
//  reviewModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    评论模型
 */

#import <Foundation/Foundation.h>
#import "OrderModel.h"

@interface reviewModel : NSObject

@property (nonatomic, strong) OrderModel *orderModel;   // 商品信息
@property (nonatomic, copy) NSString *reviewText;       // 评论内容
@property (nonatomic, strong) NSArray *photosArray;     // 图片数组
@property (nonatomic, assign) NSUInteger starNumber;    // 星星数量

@end

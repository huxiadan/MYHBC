//
//  GoodsModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic, copy) NSString *goodsName;            // 名称
@property (nonatomic, copy) NSString *goodsPrice;           // 价格
@property (nonatomic, copy) NSString *marketPrice;          // 市场价
@property (nonatomic, copy) NSString *goodsImageURL;        // 图片地址
@property (nonatomic, copy) NSString *goodsId;              // ID

@end

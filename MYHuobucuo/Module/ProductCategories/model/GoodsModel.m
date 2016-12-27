//
//  GoodsModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.goodsId = dict[@"product_id"];
    self.goodsName = dict[@"product_name"];
    self.marketPrice = dict[@"price"];
    self.goodsPrice = dict[@"sale_price"];
    self.goodsImageURL = dict[@"image"];
}

@end

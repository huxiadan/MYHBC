//
//  CollShopModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CollShopModel.h"

@implementation CollShopModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.shopId = dict[@"shop_id"];
    self.shopName = dict[@"shop_name"];
    self.shopImageURL = dict[@"shop_headimg"];
    self.isCollect = YES;
}

@end

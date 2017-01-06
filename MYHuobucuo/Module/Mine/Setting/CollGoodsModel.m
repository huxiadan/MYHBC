//
//  CollGoodsModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CollGoodsModel.h"

@implementation CollGoodsModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.goodsId = [dict objectForKey:@"product_id"];
    self.goodsName = [dict objectForKey:@"product_name"];
    self.goodsPrice = [dict objectForKey:@"sale_price"];
    self.goodsImageURL = [dict objectForKey:@"image"];
    self.isInvalid = [[dict objectForKey:@"status"] boolValue];
    
    ShareModel *share = [[ShareModel alloc] init];
    share.shareTitle = self.goodsName;
    share.shareContent = [dict objectForKey:@"product_title"];
    share.shareImageURL = self.goodsImageURL;
    share.shareURL = [dict objectForKey:@""];
    self.shareModel = share;
}

@end

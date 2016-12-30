//
//  GoodsDetailModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsDetailModel.h"

@implementation GoodsDetailModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.goodsId = dict[@"product_id"];
    self.goodsName = dict[@"product_name"];
    self.goodsPrice = dict[@"sale_price"];
    self.marketPrice = dict[@"price"];
    self.commission = dict[@"commission"];
    self.specShowImage = dict[@"image"];
    
    self.shopId = dict[@"store_id"];
    
    // 商品轮播图
    NSArray *imageList = dict[@"imageList"];
    
    NSMutableArray *tmpImageArray = [NSMutableArray arrayWithCapacity:imageList.count];
    
    for (NSDictionary *imageDict in imageList) {
        [tmpImageArray addObjectSafe:[imageDict objectForKey:@"image"]];
    }
    self.goodsImageURLArray = [tmpImageArray copy];
    
    // 商品规格
    NSArray *specArray = dict[@"optionList"];

    NSMutableArray *specTmpArray = [NSMutableArray arrayWithCapacity:specArray.count];
    
    for (NSDictionary *specTypeDict in specArray) {
        
        NSString *key = [specTypeDict objectForKey:@"option_name"];
        
        NSMutableArray *valueArray = [specTypeDict objectForKey:@"data"];
        NSMutableArray *value = [NSMutableArray arrayWithCapacity:valueArray.count];
        
        for (NSDictionary *valueDict in valueArray) {
            
            GoodsSpecModel *specModel = [[GoodsSpecModel alloc] init];
            
            specModel.specId = [valueDict objectForKey:@"product_option_id"];
            specModel.specName = [valueDict objectForKey:@"product_option_name"];
            
            [value addObjectSafe:specModel];
        }
        
        [specTmpArray addObjectSafe:@{key : [value copy]}];
    }
    
    self.specArray = [specTmpArray copy];
    
    // 规格数据查询字典数组(数量/价格)
    NSArray *specDealArray = dict[@"optionListValue"];
    
    NSMutableArray *specTmpDealArray = [NSMutableArray arrayWithCapacity:specDealArray.count];
    
    for (NSDictionary *valueDict in specDealArray) {
        GoodsSpecDealModel *model = [[GoodsSpecDealModel alloc] init];
        
        model.specGroupKey = [valueDict objectForKey:@"option_values"];
        model.specGroupPrice = [valueDict objectForKey:@"sale_price"];
        model.specGroupQuantity = [valueDict objectForKey:@"quantity"];
        
        [specTmpDealArray addObjectSafe:model];
    }
    
    self.specDealArray = [specTmpDealArray copy];
}

@end

@implementation GoodsSpecModel

@end


@implementation GoodsSpecDealModel

@end


@implementation OtherGroupModel



@end

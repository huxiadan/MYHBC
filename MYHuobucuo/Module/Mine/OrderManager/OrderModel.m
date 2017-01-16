//
//  OrderModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.goodsId = [dict objectForKey:@"product_id"];
    self.goodsImageURL = [dict objectForKey:@"image"];
    self.goodsName = [dict objectForKey:@"product_name"];
    self.goodsPrice = [dict objectForKey:@"sale_price"];
    self.goodsNumber = [[dict objectForKey:@"quantity"] integerValue];
    
    NSArray *specArray = [dict objectForKey:@"optionMsg"];
    if (specArray.count > 0) {
        
        NSMutableString *tmpSpecString = [[NSMutableString alloc] init];
        
        for (NSString *spec in specArray) {
            [tmpSpecString appendString:[NSString stringWithFormat:@"%@, ",spec]];
        }
        
        self.goodsSpecification = [tmpSpecString substringToIndex:tmpSpecString.length - 2];
    }
    
    self.isSelect = NO;
    self.isEdit = NO;
}


@end

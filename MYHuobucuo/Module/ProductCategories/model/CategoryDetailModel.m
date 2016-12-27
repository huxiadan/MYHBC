//
//  CategoryDetailModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryDetailModel.h"

@implementation CategoryDetailModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.categoryId = dict[@"category_id"];
    self.categoryName = dict[@"category_name"];
    self.categoryImageURL = dict[@"image"];
}

@end

//
//  CategoryDockModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryDockModel.h"

@implementation CategoryDockModel

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.categoryName = dict[@"category_name"];
    self.dockId = dict[@"category_id"];
}

@end

//
//  HDAreaModel.m
//  MYHuobucuo
//
//  Created by hudan on 17/1/9.
//  Copyright © 2017年 hudan. All rights reserved.
//

#import "HDAreaModel.h"

@interface HDAreaModel () <NSCopying>

@end

@implementation HDAreaModel

- (void)setValueWithArray:(NSArray *)array
{
    if (array.count == 2) {
        self.areaCode = [array objectAtIndex:0];
        self.areaName = [array objectAtIndex:1];
    }
    else {
        NSAssert(NO, @"数组数量不对");
    }
}

- (id)copyWithZone:(NSZone *)zone
{
    HDAreaModel *model = [[HDAreaModel alloc] init];
    if (model) {
        model.areaName = [self.areaName copyWithZone:zone];
        model.areaCode = [self.areaCode copyWithZone:zone];
    }
    
    return model;
}

@end

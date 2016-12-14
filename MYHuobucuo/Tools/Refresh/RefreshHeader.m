//
//  RefreshHeader.m
//  MYHuobucuo
//
//  Created by hudan on 16/9/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "RefreshHeader.h"

@implementation RefreshHeader

+ (MJRefreshNormalHeader *)headerWithTitle:(NSString *)title
                             freshingTitle:(NSString *)freshingTitle
                                freshBlock:(void (^)())freshBlock
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:freshBlock];
    
    [header setTitle:title forState:MJRefreshStateIdle];
    [header setTitle:freshingTitle forState:MJRefreshStateRefreshing];
    
    return header;
}

@end

//
//  RefreshFooter.m
//  MYHuobucuo
//
//  Created by hudan on 16/9/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "RefreshFooter.h"

@implementation RefreshFooter

+ (MJRefreshAutoFooter *)footerWithTitle:(NSString *)title
                          uploadingTitle:(NSString *)uploadingTitle
                             noMoreTitle:(NSString *)noMoreTitle
                             uploadBlock:(void(^)())uploadBlock
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:uploadBlock];
    
    // 设置文字
    [footer setTitle:title forState:MJRefreshStateIdle];
    [footer setTitle:uploadingTitle forState:MJRefreshStateRefreshing];
    [footer setTitle:noMoreTitle forState:MJRefreshStateNoMoreData];
    
    return footer;
}

@end

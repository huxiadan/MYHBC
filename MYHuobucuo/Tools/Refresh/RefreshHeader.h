//
//  RefreshHeader1.h
//  MYHuobucuo
//
//  Created by hudan on 16/9/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface RefreshHeader : MJRefreshNormalHeader

/**
    title           下拉显示的 title
    freshingTitle   刷新中显示的 title
    freshBlock      刷新动作
 */
+ (MJRefreshNormalHeader *)headerWithTitle:(NSString *)title
                             freshingTitle:(NSString *)freshingTitle
                                freshBlock:(void (^)())freshBlock;

@end

//
//  RefreshFooter.h
//  MYHuobucuo
//
//  Created by hudan on 16/9/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    MJRefresh footer 的封装
 */

#import <MJRefresh/MJRefresh.h>

@interface RefreshFooter : MJRefreshAutoFooter

/**
    title          上拉过程中显示的 title
    uploadingTitle 加载数据过程中显示的 title
    noMoreTitle    无更多数据时显示的 title
    uploadBlock    更新动作
 */
+ (MJRefreshAutoFooter *)footerWithTitle:(NSString *)title
                          uploadingTitle:(NSString *)uploadingTitle
                             noMoreTitle:(NSString *)noMoreTitle
                             uploadBlock:(void(^)())uploadBlock;

@end

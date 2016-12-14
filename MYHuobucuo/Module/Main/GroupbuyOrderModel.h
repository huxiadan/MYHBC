//
//  GroupbuyOrderModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    团购订单模型
 */

#import <Foundation/Foundation.h>
#import "ShareModel.h"

@class GroupMemberModel;

@interface GroupbuyOrderModel : NSObject

@property (nonatomic, copy) NSString *groupbuyId;           // 商品 id
@property (nonatomic, copy) NSString *goodsImageUrl;        // 商品图
@property (nonatomic, copy) NSString *goodsName;            // 商品名
@property (nonatomic, copy) NSString *wuliuInfo;            // 物流
@property (nonatomic, assign) NSUInteger groupCount;        // 团人数
@property (nonatomic, copy) NSString *groupPrice;           // 价格文字
@property (nonatomic, copy) NSString *groupPriceBig;        // 放大显示的价格
@property (nonatomic, copy) NSString *commissionString;     // 佣金
@property (nonatomic, copy) NSString *commissionShareText;  // 分享相关的佣金说明
@property (nonatomic, strong) ShareModel *shareModel;       // 分享

@property (nonatomic, assign) BOOL isGroupSuccess;          // 是否组团成功
@property (nonatomic, assign) BOOL isMyGroup;               // 是否是该用户参与的团

@property (nonatomic, assign) NSUInteger groupTime;         // 团购剩余时间
@property (nonatomic, strong) NSArray<GroupMemberModel *> *memberList;  // 参团人员猎豹

@end


// 团购用户模型

@interface GroupMemberModel : NSObject

@property (nonatomic, assign) BOOL isMaster;        // 是否团长
@property (nonatomic, copy) NSString *userIconUrl;  // 用户头像
@property (nonatomic, copy) NSString *userName;     // 用户名称
@property (nonatomic, assign) NSUInteger addTime;   // 开团/参团时间

@end

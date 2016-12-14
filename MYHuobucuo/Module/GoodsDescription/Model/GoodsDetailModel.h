//
//  GoodsDetailModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OtherGroupModel;

@interface GoodsDetailModel : NSObject

@property (nonatomic, copy) NSString *goodsName;            // 名称
@property (nonatomic, copy) NSString *goodsPrice;           // 价格
@property (nonatomic, copy) NSString *marketPrice;          // 市场价
@property (nonatomic, copy) NSString *goodsImageURL;        // 图片地址
@property (nonatomic, copy) NSString *goodsId;              // ID

// 商品详情页使用
@property (nonatomic, copy) NSString *commission;           // 佣金
@property (nonatomic, strong) NSArray *specArray;           // 规格数组 元素是字典 (key:规格  value: 规格具体选项)
@property (nonatomic, strong) NSArray *showSpecArray;       // 显示的规格数组,后台根据销量返回2种规格用于显示
@property (nonatomic, strong) NSArray *evaluateArray;       // 显示的3个评论的数组(元素为EvaluateModel对象)
@property (nonatomic, assign) NSInteger evaluateNumber;     // 评论数量
@property (nonatomic, copy) NSString *goodEvaluatePre;      // 好评率

@property (nonatomic, copy) NSString *shopName;             // 店铺名
@property (nonatomic, copy) NSString *shopIconUrl;          // 店铺图标地址
@property (nonatomic, copy) NSString *shopId;               // 店铺 ID

// 拼团使用
@property (nonatomic, assign) BOOL isGroup;                 // 是否团购
@property (nonatomic, assign) GroupType groupType;          // 拼团类型
@property (nonatomic, assign) NSUInteger groupNumber;       // 团购人数
@property (nonatomic, assign) NSUInteger hasNumber;         // 已有人数
@property (nonatomic, copy) NSString *goodsInfoString;      // 商品说明文字
@property (nonatomic, copy) NSString *fromPlace;            // 发货地点
@property (nonatomic, copy) NSString *salePromote;          // 促销信息
@property (nonatomic, strong) NSArray<OtherGroupModel *> *otherGroupsArray; // 其他拼团
@property (nonatomic, assign) NSUInteger endTime;           // 结束时间
@property (nonatomic, strong) NSArray<NSString *> *rulesArray;          // 规则

@end


// 其他拼团
@interface OtherGroupModel : NSObject

@property (nonatomic, copy) NSString *groupId;                  // 团 id
@property (nonatomic, copy) NSString *groupTitle;               // 拼团显示的 title
@property (nonatomic, copy) NSString *groupUserName;            // 团长名称
@property (nonatomic, copy) NSString *userIconUrl;              // 团长头像
@property (nonatomic, assign) NSUInteger noEnoughNumber;        // 还差人数
@property (nonatomic, assign) NSUInteger endTime;               // 结束时间

@end

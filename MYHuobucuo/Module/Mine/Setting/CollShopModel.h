//
//  CollShopModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareModel.h"

@interface CollShopModel : NSObject

@property (nonatomic, copy) NSString *shopId;           // 店铺 ID
@property (nonatomic, copy) NSString *shopName;         // 店铺名
@property (nonatomic, copy) NSString *shopImageURL;     // 店铺图片地址
@property (nonatomic, assign) ShopIconType iconType;    // 店铺图标类型
@property (nonatomic, strong) ShareModel *shareModel;   // 分享
@property (nonatomic, assign) BOOL isCollect;           // 收藏

- (void)setValueWithDict:(NSDictionary *)dict;

@end

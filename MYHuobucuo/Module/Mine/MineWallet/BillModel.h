//
//  BillModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger) {
    BillType_All = 0,       // 全部
    BillType_ByTeam,        // 团队收款
    BillType_ByDelegate,    // 代销收入
    BillType_BySelf,        // 自营收入
}BillType;

@interface BillModel : NSObject

@property (nonatomic, assign) BillType billType;    // 类型
@property (nonatomic, copy) NSString *billDate;     // 时间
@property (nonatomic, copy) NSString *billAmount;   // 金额

@end

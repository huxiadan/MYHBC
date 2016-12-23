//
//  UserManager.h
//  Huobucuo
//
//  Created by hudan on 16/9/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

/**
    用户管理类 单例
 */

#import <Foundation/Foundation.h>

#import "Singleton.h"

@interface UserManager : NSObject

SingletonH(UserManager)

// 判断是否有用户登录  登录返回 YES / 未登录返回 NO
- (BOOL)hasUser;

// 用户登出操作
- (void)userLoginOut;

@end


#pragma mark - User model
#import "MYEnumsHeader.h"
#import <UIKit/UIKit.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userIconUrl;          // 用户头像地址
@property (nonatomic, strong) UIImage *userIconImage;       // 用户头像
@property (nonatomic, assign) UserGroupType userGroupType;  // 用户类型;


@end

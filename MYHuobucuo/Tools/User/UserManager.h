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
@interface UserModel : NSObject

@property (nonatomic, copy)   NSString *userId;
@property (nonatomic, copy)   NSString *userName;
@property (nonatomic, strong) UIImage  *userIcon;


@end

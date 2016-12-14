//
//  UserManager.m
//  Huobucuo
//
//  Created by hudan on 16/9/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()

@property (nonatomic, strong) UserModel *user;

@end

@implementation UserManager

SingletonM(UserManager)

- (BOOL)hasUser
{
    return self.user == nil ? NO : YES;
}

- (void)userLoginOut
{
    if (self.user) {
        self.user = nil;
        // 清空 UserDefault
        [HDUserDefaults setObject:nil forKey:cUserid];
        [HDUserDefaults setObject:nil forKey:cUserName];
        [HDUserDefaults setObject:nil forKey:cUserIcon];
    }
}

- (UserModel *)user
{
    if (!_user) {
        id obj = [HDUserDefaults objectForKey:cUserid];
        if (obj) {
            _user = [[UserModel alloc] init];
            _user.userId = [NSString stringWithFormat:@"%@",obj];
            _user.userName = [HDUserDefaults objectForKey:cUserName];
            _user.userIcon = [HDUserDefaults objectForKey:cUserIcon];
        }
        else {
            _user = nil;
        }
    }
    return _user;
}

@end

#pragma mark
#pragma mark - UserModel
@implementation UserModel

@end

//
//  UserManager.m
//  Huobucuo
//
//  Created by hudan on 16/9/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "UserManager.h"
#import "LoginViewController.h"

@interface UserManager () <UIAlertViewDelegate>

@property (nonatomic, strong) UINavigationController *pushController;

@end

@implementation UserManager

SingletonM(UserManager)

#pragma mark - Public

- (BOOL)hasUser
{
    return self.user == nil ? NO : YES;
}

- (void)userLogin
{
    if (!self.user) {
        self.user = [[UserModel alloc] init];
    }
}

- (void)userLoginOut
{
    if (self.user) {
        self.user = nil;
        // 清空 UserDefault
        [HDUserDefaults setObject:nil forKey:cUserid];
        [HDUserDefaults setObject:nil forKey:cUserName];
        [HDUserDefaults setObject:nil forKey:cUserIcon];
        [HDUserDefaults setObject:nil forKey:cUserSex];
        [HDUserDefaults setObject:nil forKey:cUserGroupType];
        [HDUserDefaults setObject:nil forKey:cUserPhoneNumber];
        [HDUserDefaults setObject:nil forKey:cUserWechat];
        [HDUserDefaults setObject:nil forKey:cUserQQ];
        [HDUserDefaults setObject:@"0" forKey:cUserCollectionGoodsNumber];
        [HDUserDefaults setObject:@"0" forKey:cUserCollectionStoreNumber];
        [HDUserDefaults setObject:@"0" forKey:cUserWalletMoney];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLogoutNoti object:nil];
    }
}

- (void)alertToLogin:(UINavigationController *)navController
{
    self.pushController = navController;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还未登录哦~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
    [alert show];
}

- (void)saveUserBgImage:(UIImage *)image
{
    NSString *path_sandox = NSHomeDirectory();
    //设置一个图片的存储路径
    NSString *imagePath = [path_sandox stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.jpg", self.user.userId]];
    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

- (UIImage *)getUserBgImage
{
    // 读取沙盒路径图片
    NSString *imagePath = [NSString stringWithFormat:@"%@/Documents/%@.jpg",NSHomeDirectory(),self.user.userId];
    // 拿到沙盒路径图片
    UIImage *imgFromUrl = [[UIImage alloc]initWithContentsOfFile:imagePath];
    // 图片保存相册
    UIImageWriteToSavedPhotosAlbum(imgFromUrl, self, nil, nil);
    
    // 如果没有,使用默认图
    if (imgFromUrl == nil) {
        imgFromUrl = [UIImage imageNamed:@"组-28@2x"];
    }
    return imgFromUrl;
}

#pragma mark - getter
- (UserModel *)user
{
    if (!_user) {
        id obj = [HDUserDefaults objectForKey:cUserid];
        if (obj) {
            _user = [[UserModel alloc] init];
            _user.userId = [NSString stringWithFormat:@"%@",obj];
            _user.userName = [HDUserDefaults objectForKey:cUserName];
            _user.userIconUrl = [HDUserDefaults objectForKey:cUserIcon];
            _user.userGroupType = (UserGroupType)[[HDUserDefaults objectForKey:cUserGroupType] integerValue];
        }
        else {
            _user = nil;
        }
    }
    return _user;
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self.pushController pushViewController:loginVC animated:YES];
    }
}

@end

#pragma mark
#pragma mark - UserModel
@implementation UserModel

#pragma mark - Setter
- (void)setUserId:(NSString *)userId
{
    _userId = userId;
    
    [HDUserDefaults setObject:userId forKey:cUserid];
    [HDUserDefaults synchronize];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    
    [HDUserDefaults setObject:userName forKey:cUserName];
    [HDUserDefaults synchronize];
}

- (void)setUserIconUrl:(NSString *)userIconUrl
{
    _userIconUrl = userIconUrl;
    
    [HDUserDefaults setObject:userIconUrl forKey:cUserIcon];
    [HDUserDefaults synchronize];
}

- (void)setUserGroupType:(UserGroupType)userGroupType
{
    _userGroupType = userGroupType;
    
    [HDUserDefaults setObject:[NSNumber numberWithInteger:userGroupType] forKey:cUserGroupType];
    [HDUserDefaults synchronize];
}

- (void)setValueWithDict:(NSDictionary *)dict
{
    self.userId = [dict objectForKey:@"customer_id"];
    self.userName = [dict objectForKey:@"customer_name"];
    self.userIconUrl = [dict objectForKey:@"headimg"];
    self.userGroupType = [[dict objectForKey:@"customer_group_id"] integerValue];
}

@end

//
//  UMShareTool.m
//  Huobucuo
//
//  Created by hudan on 16/9/19.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "UMShareTool.h"

#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaSSOHandler.h>
#import "MYCommonHeader.h"
#import <UIImageView+WebCache.h>

#define UMSocialDataConfig [UMSocialData defaultData].extConfig

@interface UMShareTool () <UMSocialUIDelegate>

@property (nonatomic, strong) UIImageView *tempShareImageView;  // 缓存分享图片的 imageView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;

@end

@implementation UMShareTool

+ (void)registerThirdSocial
{
    // 友盟
    [UMSocialData setAppKey:APPKey_UM];
    
    // 微信
    [UMSocialWechatHandler setWXAppId:APPKey_WX appSecret:APPSecret_WX url:@""];
    
    // QQ
    [UMSocialQQHandler setQQWithAppId:APPKey_QQ appKey:APPSecret_QQ url:@""];
    [UMSocialQQHandler setSupportWebView:YES];
    
    // 微博  url需要和新浪微博后台设置的回调地址一致
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:APPKey_Sina secret:APPSecret_Sina RedirectURL:@""];
}

#pragma mark
#pragma mark - 友盟分享
- (void)createShareWithTitle:(NSString *)shareTitle content:(NSString *)shareContent imageUrl:(NSString *)shareImageUrl Url:(NSString *)shareUrl
{
    // 微信
    UMSocialDataConfig.wechatSessionData.url = shareUrl;
    UMSocialDataConfig.wechatSessionData.title = shareTitle;
    UMSocialDataConfig.wechatSessionData.shareText = shareContent;
    
    // 朋友圈
    UMSocialDataConfig.wechatTimelineData.url = shareUrl;
    UMSocialDataConfig.wechatTimelineData.title = shareTitle;
    UMSocialDataConfig.wechatTimelineData.shareText = shareContent;
    
    // QQ
    UMSocialDataConfig.qqData.url = shareUrl;
    UMSocialDataConfig.qqData.title = shareTitle;
    UMSocialDataConfig.qqData.shareText = shareContent;
    
    // QQ空间
    UMSocialDataConfig.qzoneData.url = shareUrl;
    UMSocialDataConfig.qzoneData.title = shareTitle;
    UMSocialDataConfig.qzoneData.shareText = shareContent;
    
    // 新浪微博
    UMSocialDataConfig.sinaData.shareText = [NSString stringWithFormat:@"%@.%@",shareContent, shareUrl];
    
    // 预下载分享图
    [self.tempShareImageView sd_setImageWithURL:[NSURL URLWithString:shareUrl] placeholderImage:[UIImage imageNamed:@"shareImagePlaceHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (void)toShareWithButtonType:(ShareButtonType)buttonType controller:(UIViewController *)controller finish:(void(^)(BOOL success))finishBlock
{
    NSString *sharePlat;
    
    switch (buttonType) {
        case ShareButtonType_WeiXin:
            sharePlat = UMShareToWechatSession;
            break;
        case ShareButtonType_WeixinZone:
            sharePlat = UMShareToWechatTimeline;
            break;
        case ShareButtonType_QQ:
            sharePlat = UMShareToQQ;
            break;
        case ShareButtonType_QQZone:
            sharePlat = UMShareToQzone;
            break;
        case ShareButtonType_Sina:
        {
            sharePlat = UMShareToSina;
            
            [UMSocialSnsService presentSnsController:controller appKey:APPKey_UM shareText:UMSocialDataConfig.sinaData.shareText shareImage:self.tempShareImageView.image shareToSnsNames:@[sharePlat] delegate:self];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(controller,[UMSocialControllerService defaultControllerService],YES);
            return;
        }
            break;
            
        default:
            break;
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[sharePlat] content:self.content image:self.tempShareImageView.image location:nil urlResource:nil completion:^(UMSocialResponseEntity *response) {
        if (finishBlock) {
            finishBlock(response.responseCode == UMSResponseCodeSuccess ? YES : NO);
        }
    }];
}

#pragma mark
#pragma mark - 友盟登录

- (void)umLoginWithPlat:(LoginButtonType)plat viewController:(UIViewController *)controller complete:(LoginCompleteBlock)complete{
    
    if (plat == LoginButtonType_Sina) {
        [self umLoginSinaWithController:controller complete:complete];
    }
    else if (plat == LoginButtonType_WeChat) {
        [self umLoginWeChatWithController:controller complete:complete];
    }
    else if (plat == LoginButtonType_QQ) {
        [self umLoginQQWithController:controller complete:complete];
    }
}

// 新浪微博
- (void)umLoginSinaWithController:(UIViewController *)controller
                         complete:(LoginCompleteBlock)complete
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            if (complete) {
                complete(snsAccount.unionId, snsAccount.openId, snsAccount.userName, snsAccount.iconURL);
            }
        }
    });
}

// 微信
- (void)umLoginWeChatWithController:(UIViewController *)controller
                           complete:(LoginCompleteBlock)complete
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            if (complete) {
                complete(snsAccount.unionId, snsAccount.openId, snsAccount.userName, snsAccount.iconURL);
            }
        }
    });
}

// QQ
- (void)umLoginQQWithController:(UIViewController *)controller
                       complete:(LoginCompleteBlock)complete
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(controller,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            NSDictionary *dict = [UMSocialAccountManager socialAccountDictionary];
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:snsPlatform.platformName];
            NSLog(@"\nusername = %@,\n usid = %@,\n token = %@ iconUrl = %@,\n unionId = %@,\n thirdPlatformUserProfile = %@,\n thirdPlatformResponse = %@ \n, message = %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL, snsAccount.unionId, response.thirdPlatformUserProfile, response.thirdPlatformResponse, response.message);
            
            if (complete) {
                complete(snsAccount.unionId, snsAccount.openId, snsAccount.userName, snsAccount.iconURL);
            }
        }
    });
}

- (void)setUserAfterLoginWithDict:(NSDictionary *)userInfo
{
    AppUserManager.user.userId = [userInfo objectForKey:cUserid];
    AppUserManager.user.userName = [userInfo objectForKey:cUserName];
    AppUserManager.user.userIconUrl = [userInfo objectForKey:cUserIcon];
}

@end

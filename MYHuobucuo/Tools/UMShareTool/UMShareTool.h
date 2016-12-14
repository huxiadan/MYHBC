//
//  UMShareTool.h
//  Huobucuo
//
//  Created by hudan on 16/9/19.
//  Copyright © 2016年 胡丹. All rights reserved.
//

/**
    友盟相关类 (第三方登录,分享)
 */

#import <Foundation/Foundation.h>

#import <UMSocial.h>

typedef void(^LoginCompleteBlock)(NSString *unionId, NSString *openId, NSString *userName, NSString *userIconUrl);

// 分享按钮功能类别
typedef NS_ENUM(NSInteger) {
    ShareButtonType_WeiXin = 1,     // 微信
    ShareButtonType_WeixinZone,     // 朋友圈
    ShareButtonType_QQ,             // QQ
    ShareButtonType_QQZone,         // QQ 空间
    ShareButtonType_Sina            // 新浪微博
}ShareButtonType;

// 登录按钮的平台类型
typedef NS_ENUM(NSInteger) {
    LoginButtonType_Sina = 1,
    LoginButtonType_WeChat,
    LoginButtonType_QQ,
}LoginButtonType;

@interface UMShareTool : NSObject

+ (void)registerThirdSocial;

#pragma mark - 分享
// 创建分享
/**
    分享的标题
    分享的内容
    分享的图片地址
    分享的地址
 */
- (void)createShareWithTitle:(NSString *)shareTitle
                     content:(NSString *)shareContent
                    imageUrl:(NSString *)shareImageUrl
                         Url:(NSString *)shareUrl;

// 分享按钮点击分享
/**
    分享的类型
    分享按钮的 viewController
    分享完成的 block
 */
- (void)toShareWithButtonType:(ShareButtonType)buttonType
                   controller:(UIViewController *)controller
                       finish:(void(^)(BOOL success))finishBlock;

#pragma mark - 登录

- (void)umLoginWithPlat:(LoginButtonType)plat
         viewController:(UIViewController *)controller
               complete:(LoginCompleteBlock)complete;


@end

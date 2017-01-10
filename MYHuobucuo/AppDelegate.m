//
//  AppDelegate.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "CategoryViewController.h"
#import "ShoppingCarViewController.h"
#import "MineViewController.h"
#import "PartnetViewController.h"
#import "ExtensionViewController.h"
#import "MYTabBarController.h"

#import <IQKeyboardManager.h>
#import <AFNetworkReachabilityManager.h>
#import "UMShareTool.h"
#import "HDAliPay.h"
#import "HDWeChatPay.h"
#import "MYCommonHeader.h"

@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

#pragma mark 
#pragma mark - application delegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 添加子控制器
    [self initAPPViewControllers];
    
    // 网络监听
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
    // 第三方
    // 友盟相关注册:友盟/微信/QQ/新浪微博
    [UMShareTool registerThirdSocial];
    
    // 支付注册
    // 微信
    [[HDWeChatPay shareInstance] registerApp:APPKey_WX];
    
    // 键盘适配
    [[IQKeyboardManager sharedManager] setEnable:YES];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    
    if (result == false) {
        //支付宝回调 iOS9之前
        [self alipayCallBackWithURL:url];
        
        // 微信支付回调
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    // iOS9 之后支付宝回调
    [self alipayCallBackWithURL:url];
    
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

#pragma mark 
#pragma mark - private methods

// 初始化控制器
- (void)initAPPViewControllers
{
    MainViewController *mainViewController = [[MainViewController alloc] init];
    UINavigationController *mainNav = [self navControllerWithController:mainViewController title:@"首页" image:[UIImage imageNamed:@"icon_item_shouye_n"] highlightImage:[UIImage imageNamed:@"icon_item_shouye_h"] ];
    
    CategoryViewController *twoViewController = [[CategoryViewController alloc] init];
    UINavigationController *twoNav = [self navControllerWithController:twoViewController title:@"分类" image:[UIImage imageNamed:@"icon_class_n"] highlightImage:[UIImage imageNamed:@"icon_class_h"]];
    
    ShoppingCarViewController *threeViewController = [[ShoppingCarViewController alloc] initWithShowTabBar:YES];
    UINavigationController *threeNav = [self navControllerWithController:threeViewController title:@"购物车" image:[UIImage imageNamed:@"icon_gouwuche_n"]
                                                          highlightImage:[UIImage imageNamed:@"icon_gouwuche_h"]];
    
    MineViewController *fourViewController = [[MineViewController alloc] init];
    UINavigationController *fourNav = [self navControllerWithController:fourViewController title:@"我" image:[UIImage imageNamed:@"icon_me_n"] highlightImage:[UIImage imageNamed:@"icon_me_h"]];
    
//    PartnetViewController *fiveViewController = [[PartnetViewController alloc] init];
//    [fiveViewController.view setBackgroundColor:[UIColor yellowColor]];
//    UINavigationController *fiveNav = [self navControllerWithController:fiveViewController title:@"招募合伙人" image:nil highlightImage:nil];
//    
//    ExtensionViewController *sixViewController = [[ExtensionViewController alloc] init];
//    [sixViewController.view setBackgroundColor:[UIColor greenColor]];
//    UINavigationController *sixNav = [self navControllerWithController:sixViewController title:@"产品推广" image:nil highlightImage:nil];
    
    
    MYTabBarController *tabBarController = [MYTabBarController sharedTabBarController];
    [tabBarController setViewControllers:@[mainNav, twoNav, threeNav, fourNav]];
    [tabBarController setAllChilControllersArray:@[mainNav, twoNav, threeNav, fourNav]];//, fiveNav, sixNav]];
    
    [tabBarController setItemFontNormalColor:HexColor(0x666666)];
    [tabBarController setItemFontSelectColor:HexColor(0xe44a62)];
    [tabBarController setItemFontSize:12.f];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
}

- (UINavigationController *)navControllerWithController:(UIViewController *)controller title:(NSString *)title image:(UIImage *)image highlightImage:(UIImage *)hihglightIamge
{
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    controller.title = title;
    navController.title = title;
    navController.tabBarItem.image = image;
    navController.tabBarItem.selectedImage = hihglightIamge;
    
    return navController;
}

#pragma mark - 回调
// 微信回调
- (void)onResp:(BaseResp *)resp
{
    
}

// 支付宝回调
- (void)alipayCallBackWithURL:(NSURL *)url
{
    if ([url.host isEqualToString:@"safepay"]) {
        
        NSString *urlStr = [url absoluteString];
        
        BOOL payStatus = NO;
        
        if ([urlStr rangeOfString:@"ResultStatus%22:%226001"].length>0)
        {
            DLog(@"用户取消操作");
            payStatus = YES;
        }
        else if ([urlStr rangeOfString:@"ResultStatus%22:%229000"].length>0)
        {
            DLog(@"交易成功");
        }
        else if ([urlStr rangeOfString:@"ResultStatus%22:%228000"].length>0)
        {
            DLog(@"正在处理中");
        }
        else if ([urlStr rangeOfString:@"ResultStatus%22:%224000"].length>0)
        {
            DLog(@"订单支付失败");
        }
        else if ([urlStr rangeOfString:@"ResultStatus%22:%226002"].length>0)
        {
            DLog(@"网络连接出错");
        }
        else
        {
            DLog(@"订单支付失败");
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AlipayDidFinishPayNotification object:[NSNumber numberWithBool:payStatus]];
        
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            DLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            DLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
}

// 本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
//    NSString *notMess = [notification.userInfo objectForKey:@"key"];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"本地通知(前台)"
//                                                    message:notMess
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge--;
    badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    // 在不需要再推送时，可以取消推送
   
}


@end

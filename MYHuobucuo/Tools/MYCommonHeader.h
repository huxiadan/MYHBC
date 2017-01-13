//
//  MYCommonHeader.h
//  Huobucuo
//
//  Created by hudan on 16/9/12.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#ifndef MYCommonHeader_h
#define MYCommonHeader_h

// 第三方
#define APPKey_UM @""
#define APPSecret_UM @""

#define APPKey_WX @"wxfcb744634f84c315"
#define APPSecret_WX @"f56bd1391ca21494c7d87cdca0492a57"

#define APPKey_QQ @""
#define APPSecret_QQ @""

#define APPKey_Sina @""
#define APPSecret_Sina @""

#define APPKey_Alipay @""
//#define APPSecret_Alipay @""

// 用户信息
#define cUserid @"MYUserId"     // 用户 ID
#define cUserName @"MYUserName" // 用户名称
#define cUserIcon @"MYUserIcon" // 用户头像地址
#define cUserSex @"MYUserSex"   // 用户性别
#define cUserGroupType @"MYUserGroupType"       // 用户所属类别
#define cUserPhoneNumber @"MYUserPhoneNumber"   // 用户手机号
#define cUserWechat @"MYUserWechat"             // 用户微信
#define cUserQQ @"MYUserQQ"                     // 用户 QQ
#define cUserCollectionGoodsNumber @"MYUserCollectionGoodsNumber"  // 收藏的商品数量
#define cUserCollectionStoreNumber @"MYUserCollectionStoreNumber"  // 关注的店铺数量
#define cUserWalletMoney @"MYUserWalletMoney"   // 用户钱包金额数量
#define cUserAddressName @"MYUserAddressName"   // 用户收货地址名称
#define cUserAddressPhone @"MYUserAddressPhone" // 用户收货地址电话
#define cUserAddressProvice @"MYUserAddressProvice" // 用户收货地址省份
#define cUserAddressCity @"MYUserAddressCity"       // 用户收货地址城市
#define cUserAddressArea @"MYUserAddressArea"       // 用户收货地址地区
#define cUserAddressAddress @"MYUserAddressAddress" // 用户收货地址详细地址

// 设置信息
#define cUserSettingAPNS @"MYUserSettingAPNS"    // 是否使用消息推送
#define cUserSettingVoice @"MYUserSettingVoice"  // 是否开启声音震动
#define cUserSettingAPNSDetail @"MYUserSettingAPNSDetail"   // 是否显示推送详情
#define cUserSettingNotDisturbAtNight @"MYUserSettingNotDisturbAtNight"   // 是否夜间防骚扰

// 设备信息
#define cVersion @"MYAppVersion"    // app 版本号

// App存储
#define cSearchHistory @"MYSearchHistory"   // 搜索历史数组
#define cIsPlayGuideImage @"MYIsPlayGuideImage"   // 是否播放过引导页

// 宏定义
#define viewControllerBgColor HexColor(0xeeefef)
#define viewControllerTitleFontSize fScreen(36)
#define viewControllerTitleColor HexColor(0x333333)

#define kStatusSuccessCode @"10000"

// 通知
#pragma mark
#pragma mark - APP 内部通知
#define kAddressDidChangeNoti @"kMYAddressChangeNotification"   // 地址界面选择地址返回上级
#define kAddressToChangeNoti @"kMYAddressToChangeNoti"          // 去选择地址界面
#define kUserHeaderIconChange @"kMYUserHeaderIconChange"        // 用户头像变更通知
#define kUserLoginNoti @"kMYUserLoginNoti"                      // 用户登录通知
#define kUserLogoutNoti @"kMYUserLogoutNoti"                    // 用户退出通知
#define kGoodsSpecSelectPriceChangeNoti @"kGoodsSpecSelectPriceChangeNoti"  // 商品详情规格选择后价格改变的通知
#define kGoodsShowSpecSelectViewNoti @"kGoodsShowSpecSelectViewNoti"    // 商品详情规格选择界面弹出通知


#endif /* MYCommonHeader_h */

//
//  MYEnumsHeader.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

#ifndef MYEnumsHeader_h
#define MYEnumsHeader_h

#pragma mark 地址 picker 的类型
typedef NS_ENUM(NSInteger) {
    AddressDataPickerTag_Provience = 1,        // 省份
    AddressDataPickerTag_City,                 // 城市/区
    AddressDataPickerTag_Area,                 // 县
}AddressDataPickerTag;

#pragma mark 百县百品类型
typedef NS_ENUM(NSInteger) {
    BaiXianBaiPinCellType_MasterFree = 0,       // 团长免单
    BaiXianBaiPinCellType_Normal,               // 普通(佣金团)
    BaiXianBaiPinCellType_LimitTime,            // 限时
}BaiXianBaiPinCellType;

#pragma mark 店铺标识类型
typedef NS_ENUM(NSInteger) {
    ShopIconType_None = 0,
    ShopIconType_Brand,     // 品牌专卖
    ShopIconType_Personal,  // 个人店铺
    ShopIconType_Official,  // 官方旗舰
    ShopIconType_Company,   // 企业专营
}ShopIconType;

#pragma mark 拼团类型
typedef NS_ENUM(NSInteger) {
    GroupType_MasterFree = 0,       // 团长免单团
    GroupType_Normal,               // 普通(佣金团)
    GroupType_Limit,                // 限时秒杀团
}GroupType;

#pragma mark 千县拼团界面分类类型
typedef NS_ENUM(NSInteger) {
    GroupBuyType_Recommend = 0,         // 推荐
    GroupBuyType_LimitTime,             // 限时
    GroupBuyType_Normal,                // 普通,返佣
    GroupBuyType_MasterFree,            // 团长免单
}GroupBuyType;

#pragma mark 我的收藏类型
typedef NS_ENUM(NSInteger)
{
    MineUserInfoButtonType_goods = 0,    // 收藏的商品
    MineUserInfoButtonType_store,        // 收藏的店铺
}MineUserInfoButtonType;

#pragma mark 我的订单类型
typedef NS_ENUM(NSInteger) {
    MineOrderType_All = 0,      // 全部
    MineOrderType_WaitPay,      // 待付款
    MineOrderType_WaitSend,     // 待发货
    MineOrderType_WaitReceive,  // 待收货
    MineOrderType_WaitEvaluate, // 待评价
}MineOrderType;

#pragma mark 订单店铺状态类型
typedef NS_ENUM(NSInteger) {
    OrderShopState_WaitPay = 1,     // 待付款/待成团
    OrderShopState_WaitSend,        // 待发货
    OrderShopState_WaitReceive,     // 待收货
    OrderShopState_WaitEvaluate,    // 待评价
    OrderShopState_NoShow,          // 不显示
    OrderShopState_Over_Success,    // 已完成(拼团成功)
    OrderShopState_Over_Fail,       // 已完成(拼团失败)
}OrderShopState;

#pragma mark 支付类型
typedef NS_ENUM(NSInteger) {
    PayStyle_Default = -1,          // 无
    PayStyle_AliPay = 0,            // 支付宝支付
    PayStyle_Wechat                 // 微信支付
}PayStyle;

#pragma mark 分享类型
typedef NS_ENUM(NSInteger) {
    ShareType_WeChat = 0,    // 微信
    ShareType_QQ,            // QQ
    ShareType_Weibo,         // 微博
    ShareType_Message,       // 短信
    ShareType_link,          // 链接
}ShareType;

#pragma mark 验证码类型
typedef NS_ENUM(NSInteger) {
    MessageCheckCodeType_Register,      // 注册验证码
    MessageCheckCodeType_ChangePwd,     // 修改密码验证码
}MessageCheckCodeType;

#pragma mark 用户类型
typedef NS_ENUM(NSInteger) {
    UserGroupType_Normal,       // 普通用户
    UserGroupType_Distributor,  // 分销商用户
    UserGroupType_Provider      // 供应商用户
}UserGroupType;


#pragma mark 评价类型
typedef NS_ENUM(NSInteger) {
    EvaluateType_All = 0,       // 全部评价
    EvaluateType_Best,          // 好评
    EvaluateType_Good,          // 中评
    EvaluateType_Bad            // 差评
}EvaluateType;


#pragma mark 收藏类型
typedef NS_ENUM(NSInteger) {
    CollectionGoodsType_Invalid = 1,    // 失效的商品
    CollectionGoodsType_Normal          // 正常收藏的商品
}CollectionGoodsType;



#endif /* MYEnumsHeader_h */

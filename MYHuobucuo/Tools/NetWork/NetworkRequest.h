//
//  NetworkRequest.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/24.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddressModel;

#define NetworkManager [NetworkRequest sharedNetworkRequest]

typedef void(^FinishBlock)(id jsonData, NSError *error);

@interface NetworkRequest : NSObject

// 单例
+ (NetworkRequest *)sharedNetworkRequest;

// 测试 api
- (void)testAPI:(FinishBlock)finishBlock;

#pragma mark
#pragma mark - Category

/**
 获取分类dock 列表数据

 @param finishBlock 请求结果 block
 */
- (void)getCategoryDockListWithBlock:(FinishBlock)finishBlock;


/**
 获取 dock 下级分类列表

 @param parentId 上级 dock 的 id
 @param finishBlock  请求结果 block
 */
- (void)getCategorySubCategoryListWithParentId:(NSString *)parentId finishBlock:(FinishBlock)finishBlock;


/**
 分类下具体商品列表

 @param categoryId 分类的 id
 @param page  页数
 @param finishBlock 请求结果 block
 */
- (void)getCategoryDetailListWithCategoryId:(NSString *)categoryId page:(NSUInteger)page finishBlock:(FinishBlock)finishBlock;


/**
 获取商品的详细信息

 @param goodsId 商品 id
 @param finishBlock  请求结果 block
 */
- (void)getGoodsInfoWithGoodsId:(NSString *)goodsId finishBlock:(FinishBlock)finishBlock;


/**
 获取商品评价

 @param goodsId 商品 id
 @param page  评价的页数
 @param pageSize 该页的大小
 @param evaluateType 请求类型(好评/中评/差评)
 @param finishBlock 请求结果 block
 */
- (void)getGoodsEvaluateWithGoodsId:(NSString *)goodsId page:(NSUInteger)page pageSize:(NSUInteger)pageSize evaluateType:(EvaluateType)evaluateType finishBlock:(FinishBlock)finishBlock;


/**
 商品收藏

 @param goodsId 商品 id
 @param shopId  商品所属店铺 id
 @param finishBlock  请求结果 block
 */
- (void)userCollectGoodsWithGoodsId:(NSString *)goodsId shopId:(NSString *)shopId finishBlock:(FinishBlock)finishBlock;


/**
 商品取消收藏

 @param goodsId 商品 id
 @param shopId  商品所属店铺 id
 @param finishBlock  请求结果 block
 */
- (void)userDisCollectGoodsWithGoodsId:(NSString *)goodsId shopId:(NSString *)shopId finishBlock:(FinishBlock)finishBlock;


/**
 店铺关注

 @param shopId 店铺 id
 @param storeId 店铺所属商城 id
 @param finishBlock 请求结果 block
 */
- (void)userCollectShopWithShopId:(NSString *)shopId storeId:(NSString *)storeId finishBlock:(FinishBlock)finishBlock;


/**
 店铺取消关注

 @param shopId 店铺 id
 @param storeId 店铺所属商城 id
 @param finishBlock 请求结果 block
 */
- (void)userDisCollectionShopWithShopId:(NSString *)shopId storeId:(NSString *)storeId finishBlock:(FinishBlock)finishBlock;

#pragma mark
#pragma mark - ShoppingCar

/**
 添加购物车

 @param goodsId 商品 id
 @param goodsSpec  规格字符串(规格间以下划线拼接)
 @param orderType  类型(普通商品/拼团商品)
 @param number 数量
 @param finishBlock 请求结果 block
 */
- (void)addGoodsToShoppingCarWithGoodsId:(NSString *)goodsId goodsSpecString:(NSString *)goodsSpec orderType:(GoodsType)orderType number:(NSUInteger)number finishBlock:(FinishBlock)finishBlock;

// 获取购物车数据
- (void)getShoppingCarInfoWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize finishBlock:(FinishBlock)finishBlock;

// 更新购物车商品的数量
- (void)updateGoodsNumber:(NSInteger)goodsNumber goodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock;

// 删除购物车中指定商品
- (void)deleteGoodsWithGoodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock;

// 清空购物车
- (void)deleteClearShoppingCar:(FinishBlock)finishBlock;

#pragma mark 
#pragma mark - Order

/**
 获取收货地址列表

 @param finishBlock 请求结果 block
 */
- (void)getAddressListWithBlock:(FinishBlock)finishBlock;


#pragma mark
#pragma mark - User

/**
 获取验证码

 @param phoneNumber 手机号码
 @param type 类型(注册验证码/修改密码验证码)
 @param finishBlock 请求结果 block
 */
- (void)getCheckCodeWithPhoneNumber:(NSString *)phoneNumber type:(MessageCheckCodeType)type finishBlock:(FinishBlock)finishBlock;


/**
 用户登录

 @param userName 用户名
 @param password 密码
 @param openId 第三方 openId
 @param unionId  第三方 unionId
 @param finishBlock  请求结果 block
 */
- (void)userLoginWithUserName:(NSString *)userName password:(NSString *)password openId:(NSString *)openId unionId:(NSString *)unionId finishBlock:(FinishBlock)finishBlock;


/**
 用户注册

 @param userName 用户名
 @param password 密码
 @param openId 第三方 openId
 @param unionId  第三方 unionId
 @param finishBlock  请求结果 block
 */
- (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password openId:(NSString *)openId unionId:(NSString *)unionId finishBlock:(FinishBlock)finishBlock;


/**
 获取用户信息

 @param finishBlock 请求结果 block
 */
- (void)getUserInfoWifhFinish:(FinishBlock)finishBlock;


/**
 获取收藏商品列表

 @param page 页数
 @param pageSize 页大小
 @param collectionType 收藏商品类型(失效/未失效)
 @param finishBlock <#finishBlock description#>
 */
- (void)getUserCollectGoodsListWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize collectionType:(CollectionGoodsType)collectionType finishBlock:(FinishBlock)finishBlock;


/**
 获取关注店铺列表

 @param page 页数
 @param pageSize 页大小
 @param finishBlock 请求结果 block
 */
- (void)getUserCollectStoreListWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize finishBlock:(FinishBlock)finishBlock;


/**
 收货地址新增和修改

 @param addressModel 地址模型
 @param finishBlock 请求结果 block
 */
- (void)updateUserAddressWithModel:(AddressModel *)addressModel finishBlock:(FinishBlock)finishBlock;


/**
 删除收货地址

 @param addressId 地址的 id
 @param finishBlock  请求结果 block
 */
- (void)deleteUserAddressWithAddressId:(NSString *)addressId finishBlock:(FinishBlock)finishBlock;

#pragma mark 
#pragma mark - Pay
// 支付宝支付与服务器的校验
- (void)aliPayCheckWithOrderID:(NSString *)out_trade_no payMoney:(NSString *)payMoney name:(NSString *)name
                   finish:(FinishBlock)finishBlock;


- (void)networkWithUrl:(NSString *)urlString postParametersDict:(NSDictionary *)parametersDict
           finishBlock:(FinishBlock)finishBlock;
@end

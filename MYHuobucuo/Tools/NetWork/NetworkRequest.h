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
// 获取分类dock 列表数据
- (void)getCategoryDockListWithBlock:(FinishBlock)finishBlock;

// 获取 dock 下级分类列表
- (void)getCategorySubCategoryListWithParentId:(NSString *)parentId finishBlock:(FinishBlock)finishBlock;

// 分类下具体商品列表
- (void)getCategoryDetailListWithCategoryId:(NSString *)categoryId page:(NSUInteger)page finishBlock:(FinishBlock)finishBlock;

// 获取商品的详细信息
- (void)getGoodsInfoWithGoodsId:(NSString *)goodsId finishBlock:(FinishBlock)finishBlock;

// 获取商品评价
- (void)getGoodsEvaluateWithGoodsId:(NSString *)goodsId page:(NSUInteger)page pageSize:(NSUInteger)pageSize evaluateType:(EvaluateType)evaluateType finishBlock:(FinishBlock)finishBlock;

// 商品收藏
- (void)userCollectGoodsWithGoodsId:(NSString *)goodsId shopId:(NSString *)shopId finishBlock:(FinishBlock)finishBlock;

// 店铺关注
- (void)userCollectShopWithShopId:(NSString *)shopId storeId:(NSString *)storeId finishBlock:(FinishBlock)finishBlock;

#pragma mark
#pragma mark - ShoppingCar
// 获取购物车数据
- (void)getShoppingCarInfo:(FinishBlock)finishBlock;

// 更新购物车商品的数量
- (void)updateGoodsNumber:(NSInteger)goodsNumber goodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock;

// 删除购物车中指定商品
- (void)deleteGoodsWithGoodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock;

// 清空购物车
- (void)deleteClearShoppingCar:(FinishBlock)finishBlock;

#pragma mark 
#pragma mark - Order
// 查询收货地址列表
- (void)getAddressListWithBlock:(FinishBlock)finishBlock;


#pragma mark
#pragma mark - User
// 获取验证码
- (void)getCheckCodeWithPhoneNumber:(NSString *)phoneNumber type:(MessageCheckCodeType)type finishBlock:(FinishBlock)finishBlock;

// 登录
- (void)userLoginWithUserName:(NSString *)userName password:(NSString *)password openId:(NSString *)openId unionId:(NSString *)unionId finishBlock:(FinishBlock)finishBlock;

// 注册
- (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password openId:(NSString *)openId unionId:(NSString *)unionId finishBlock:(FinishBlock)finishBlock;

// 获取用户信息
- (void)getUserInfoWifhFinish:(FinishBlock)finishBlock;

// 获取收藏商品列表
- (void)getUserCollectGoodsListWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize collectionType:(CollectionGoodsType)collectionType finishBlock:(FinishBlock)finishBlock;

// 获取关注店铺列表
- (void)getUserCollectStoreListWithPage:(NSUInteger)page pageSize:(NSUInteger)pageSize finishBlock:(FinishBlock)finishBlock;

// 收货地址新增和修改
- (void)updateUserAddressWithModel:(AddressModel *)addressModel finishBlock:(FinishBlock)finishBlock;

// 删除收货地址
- (void)deleteUserAddressWithAddressId:(NSString *)addressId finishBlock:(FinishBlock)finishBlock;

#pragma mark 
#pragma mark - Pay
// 支付宝支付与服务器的校验
- (void)aliPayCheckWithOrderID:(NSString *)out_trade_no payMoney:(NSString *)payMoney name:(NSString *)name
                   finish:(FinishBlock)finishBlock;


- (void)networkWithUrl:(NSString *)urlString postParametersDict:(NSDictionary *)parametersDict
           finishBlock:(FinishBlock)finishBlock;
@end

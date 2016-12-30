//
//  NetworkRequest.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/24.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "NetworkRequest.h"

#import "MYProgressHUD.h"
#import "HBtools.h"

#import <AFNetworking.h>

// 正式网
//#define kNetworkRequestHeader @""

// 测试网
#define kNetworkRequestHeader @"http://test.huobucuo.cn/coreapi/"

#define kNetworkTimeout 30.f
#define kParamKeySign @"sign"
#define kParamKeyTimestamp @"timestamp"
#define kParamKeyCustomerId @"customerId"

#define kRequestTime [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue]


@interface NetworkRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

@property (nonatomic, copy) NSComparator sortCompara;

@end

@implementation NetworkRequest

+ (NetworkRequest *)sharedNetworkRequest
{
    static NetworkRequest *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkRequest alloc] init];
    });
    return sharedInstance;
}

- (void)testAPI:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:@{@"orderType":@1,
                                   @"page":@1,
                                   @"size":@10,
                                   kParamKeyCustomerId:@"",
                                   kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                                  }];
    
    NSString *string1 = [self paramsToMD5:postDict];
    NSString *signString = [self makeSignString:string1];
    
    [postDict setObjectSafe:signString forKey:kParamKeySign];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=order&c=reader&a=listorder", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

#pragma mark 
#pragma mark - Category
// 获取分类dock 列表数据
- (void)getCategoryDockListWithBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"parentId":@"0",
                               @"isall":@NO,
                               kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                               };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObject:signString forKey:kParamKeySign];
    [postDict setObject:@1 forKey:@"page"];
    [postDict setObject:@"" forKey:@"size"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=product&c=Category&a=listCategorys", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

// 获取 dock 下级分类列表
- (void)getCategorySubCategoryListWithParentId:(NSString *)parentId finishBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"parentId":parentId,
                               @"isall":@YES,
                               kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                               };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObject:signString forKey:kParamKeySign];
    [postDict setObject:@1 forKey:@"page"];
    [postDict setObject:@"" forKey:@"size"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=product&c=Category&a=listCategorys", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

// 分类下具体商品列表
- (void)getCategoryDetailListWithCategoryId:(NSString *)categoryId page:(NSUInteger)page finishBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"categoryId":categoryId,
                               @"page":[NSNumber numberWithInteger:page],
                               @"size":@20,
                               kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                               };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObject:signString forKey:kParamKeySign];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=product&c=reader&a=listproducts", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

// 获取商品的详细信息
- (void)getGoodsInfoWithGoodsId:(NSString *)goodsId finishBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"productId" : goodsId,
                               kParamKeyTimestamp : [NSNumber numberWithInteger:time]
                               };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObject:signString forKey:kParamKeySign];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=product&c=reader&a=getProductInfo", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

#pragma mark
#pragma mark - User

// 获取验证码
- (void)getCheckCodeWithPhoneNumber:(NSString *)phoneNumber type:(MessageCheckCodeType)type finishBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"telephone":phoneNumber,
                               @"type":[NSNumber numberWithInteger:type],
                               @"msg":@"",
                               kParamKeyTimestamp:[NSNumber numberWithInteger:time]};
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObjectSafe:signString forKey:kParamKeySign];
    [postDict setObjectSafe:@"" forKey:@"ip"];
    [postDict setObjectSafe:@"" forKey:@"cfrom"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=dev&c=sms&a=sendmsg", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

// 登录
- (void)userLoginWithUserName:(NSString *)userName password:(NSString *)password openId:(NSString *)openId unionId:(NSString *)unionId finishBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"telephone":userName,
                               @"password":password,
                               @"openid":openId,
                               @"unionid":unionId,
                               kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                               };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObjectSafe:signString forKey:kParamKeySign];
    [postDict setObjectSafe:@"" forKey:@"ip"];
    [postDict setObjectSafe:@"" forKey:@"cfrom"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=user&c=customer&a=cklogin", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

// 注册
- (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password openId:(NSString *)openId unionId:(NSString *)unionId finishBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{@"openid":openId,
                              @"unionid":unionId,
                              @"telephone":userName,
                              @"password":password,
                              kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                              };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObjectSafe:@"" forKey:@"ip"];
    [postDict setObjectSafe:@"" forKey:@"cfrom"];
    [postDict setObjectSafe:@"" forKey:@"referid"];
    [postDict setObjectSafe:signString forKey:kParamKeySign];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=user&c=customer&a=register", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

#pragma mark
#pragma mark - Order

// 查询收货地址列表
- (void)getAddressListWithBlock:(FinishBlock)finishBlock
{
    NSInteger time = kRequestTime;
    
    NSDictionary *signDict = @{kParamKeyCustomerId:AppUserManager.user.userId,
                               kParamKeyTimestamp:[NSNumber numberWithInteger:time]
                               };
    
    NSString *string1 = [self paramsToMD5:signDict];
    NSString *signString = [self makeSignString:string1];
    
    NSMutableDictionary *postDict = [NSMutableDictionary dictionaryWithDictionary:signDict];
    [postDict setObject:signString forKey:kParamKeySign];
    
    NSString *urlString = [NSString stringWithFormat:@"%@index.php?m=user&c=address&a=listaddress", kNetworkRequestHeader];
    [self networkWithUrl:urlString postParametersDict:postDict finishBlock:finishBlock];
}

#pragma mark 
#pragma mark - ShoppingCar
- (void)getShoppingCarInfo:(FinishBlock)finishBlock
{
    NSString *pageStr = [NSString stringWithFormat:@"%d",1];
    NSString *countStr = [NSString stringWithFormat:@"%d",10];
    
    NSDictionary *paDic = [NSDictionary dictionaryWithObjectsAndKeys:
                           pageStr, @"page",
                           countStr,@"count",
                           nil];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                paDic,@"pagination",
                                nil];
    NSString *urlStr = [NSString stringWithFormat:@"http://www.1233go.com/ECMobile/?url=/shop/list"];
    
    [self networkWithUrl:urlStr postParametersDict:dictionary finishBlock:finishBlock];
}

- (void)updateGoodsNumber:(NSInteger)goodsNumber goodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock
{

}

- (void)deleteGoodsWithGoodsId:(NSString *)goodsId finish:(FinishBlock)finishBlock
{}

- (void)deleteClearShoppingCar:(FinishBlock)finishBlock
{}

- (void)aliPayCheckWithOrderID:(NSString *)out_trade_no payMoney:(NSString *)payMoney name:(NSString *)name finish:(FinishBlock)finishBlock
{}


#pragma mark
#pragma mark - Private

- (NSString *)makeSignString:(NSString *)md5String
{
    return [[[HBtools sharedInstance] MD5forString:[NSString stringWithFormat:@"uu#m!aap%@",md5String]] uppercaseString];
}

// 参数排序处理成字符串并进行 MD5加密
- (NSString *)paramsToMD5:(NSDictionary *)paramsDict
{
    // 排序
    NSArray *sortArray = paramsDict.allKeys;
    NSArray *sortResultArray = [sortArray sortedArrayUsingComparator:self.sortCompara];
    
    // 拼接
    NSInteger count = sortResultArray.count;
    NSMutableString *tmpReturnString = [[NSMutableString alloc] init];
    for (NSInteger index = 0; index < count; index++) {
        NSString *key = [sortResultArray objectAtIndex:index];
        
        NSString *value = [NSString stringWithFormat:@"%@", [paramsDict objectForKey:key]];
        
        NSString *appendString = [NSString stringWithFormat:@"%@=%@&", key, value];
        
        [tmpReturnString appendString:appendString];
    }
    
    // 加密
    NSString *returnString = [[HBtools sharedInstance] MD5forString:[tmpReturnString substringToIndex:tmpReturnString.length - 1]];     // 去除最后的&
    
    return returnString;
}


- (void)networkWithUrl:(NSString *)urlString postParametersDict:(id)parameters finishBlock:(FinishBlock)finishBlock
{
    // 判断网络环境
    if (![self isNetworkCanUse]) {
        [MYProgressHUD showAlertWithMessage:@"亲，没有网络哦~"];
        return;
    }
    
    // 请求数据
    [self.httpSessionManager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(nil, error);
        }
    }];
    
    

 
}

/**
 *  判断网络是否可用
 *
 *  @return YES: 网络可用 / NO: 网络不可用
 */
- (BOOL)isNetworkCanUse
{
    //    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                break;
            }
            default:
                break;
        }
        
        NSLog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
        
    }];
    
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}


#pragma mark - Getter
- (NSComparator)sortCompara
{
    if (!_sortCompara) {
        NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
        NSWidthInsensitiveSearch|NSForcedOrderingSearch;
        NSComparator sort = ^(NSString *obj1,NSString *obj2){
            NSRange range = NSMakeRange(0,obj1.length);
            return [obj1 compare:obj2 options:comparisonOptions range:range];
        };
        _sortCompara = sort;
    }
    return _sortCompara;
}

- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kNetworkRequestHeader]];
        _httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _httpSessionManager.requestSerializer.timeoutInterval = kNetworkTimeout;
        
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.readingOptions = NSJSONReadingAllowFragments;
        _httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _httpSessionManager.responseSerializer = serializer;
        _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    }
    return _httpSessionManager;
}

- (AFNetworkReachabilityManager *)reachability
{
    if (!_reachability) {
        _reachability = [AFNetworkReachabilityManager sharedManager];
        [_reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            if (status == AFNetworkReachabilityStatusNotReachable) {
                // 无网络
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无网络" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
    return _reachability;
}
@end

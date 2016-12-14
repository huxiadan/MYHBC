//
//  NetworkRequest.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/24.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "NetworkRequest.h"

#import "MYProgressHUD.h"

#import <AFNetworking.h>

// 正式网
#define kNetworkRequestHeader @""

// 测试网
//#define kNetworkRequestHeader @"test.huobucuo.com"

#define kNetworkTimeout 30.f

@interface NetworkRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

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

- (void)userLoginWithUserName:(NSString *)userName password:(NSString *)password finishBlock:(FinishBlock)finishBlock
{}

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
    
//    [self netRequestWithUrl:urlStr requestTag:requestTag postDictionary:dictionary finishBlock:finishBlock];
    
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
- (void)networkWithUrl:(NSString *)urlString postParametersDict:(NSDictionary *)parametersDict finishBlock:(FinishBlock)finishBlock
{
    // 判断网络环境
//    if (![self isNetworkCanUse]) {
//        [MYProgressHUD showAlertWithMessage:@"亲，没有网络哦~"];
//        return;
//    }
    
    // 请求数据
    [self.httpSessionManager POST:urlString parameters:parametersDict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishBlock) {
            finishBlock(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (finishBlock) {
            finishBlock(nil, error);
        }
    }];
    
    
    // 测试
//    NSURL *URL = [NSURL URLWithString:@"http://www.jsonlint.com/"];
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    
//    [manager POST:URL.absoluteString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error.localizedDescription);
//    }];
//    
 
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
- (AFHTTPSessionManager *)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kNetworkRequestHeader]];
        _httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _httpSessionManager.requestSerializer.timeoutInterval = kNetworkTimeout;
        
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        serializer.readingOptions = NSJSONReadingAllowFragments;
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

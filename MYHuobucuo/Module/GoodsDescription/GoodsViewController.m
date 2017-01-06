//
//  GoodsDetailController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/14.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsViewController.h"
#import "HDPageViewController.h"
#import "GoodsDetailController.h"
#import "GoodsDetailModel.h"
#import "EvaluateModel.h"
#import "GoodsDetailPhotoController.h"
#import "GoodsDetailBottomView.h"
#import "ShareView.h"
#import "EvaluateController.h"
#import "StoreViewController.h"
#import "PayOrderDetailController.h"
#import "MainViewController.h"
#import "MYTabBarController.h"
#import "NetworkRequest.h"

#import <Masonry.h>

@interface GoodsViewController () <HDPageViewControllerDelegate>

// data
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, strong) GoodsDetailModel *goodsModel;


// UI
@property (nonatomic, strong) HDPageViewController *pageViewController;
@property (nonatomic, strong) GoodsDetailBottomView *bottomView;               // 底部视图
@property (nonatomic, strong) UIView *goodsMoreView;                           // 右上角更多

@end

@implementation GoodsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    [self hideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goodsId = @"13388";
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DLog(@"dealloc");
}

- (instancetype)initWithGoodsId:(NSString *)goodsId
{
    if (self = [super init]) {
        
        self.goodsId = goodsId;
    }
    return self;
}

- (void)requestData
{
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager getGoodsInfoWithGoodsId:self.goodsId finishBlock:^(id jsonData, NSError *error) {
        if (error) {
            
            DLog(@"%@",error.localizedDescription);
        }
        else {
            NSDictionary *jsonDict = (NSDictionary *)jsonData;
            
            NSDictionary *statusDict = jsonDict[@"status"];
            
            if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                
                [MYProgressHUD showAlertWithMessage:statusDict[@"msg"]];
            }
            else {
                NSDictionary *dataDict = jsonDict[@"data"];
                
                GoodsDetailModel *goodsModel = [[GoodsDetailModel alloc] init];
                
                [goodsModel setValueWithDict:dataDict];
                
                goodsModel.showSpecArray = @[@"颜色: 白色,黑色", @"尺寸: S/M/L"];
                
//                goodsModel.specArray = @[@{@"颜色":@[@"白色", @"黑色", @"红色degg", @"隔壁老王之绿色", @"岛国电影之黄色"]},
//                                    @{@"果实种类":@[@"自然系", @"超人系", @"动物系"]},
//                                    @{@"果实能力":@[@"响雷果实", @"沙沙果实", @"橡胶果实", @"重力果实", @"飘飘果实", @"透明果实", @"花花果实", @"斑马果实", @"震震果实", @"不死鸟果实", @"钢化膜果实"]}];
                
                goodsModel.evaluateNumber = 9987;
                
                goodsModel.goodEvaluatePre = @"99.7%";
                
                // 评价接口
                [NetworkManager getGoodsEvaluateWithGoodsId:@"264" page:1 pageSize:3 evaluateType:EvaluateType_Best finishBlock:^(id jsonData, NSError *error) {
                    
                    if (error) {
                        DLog(@"%@",error.localizedDescription);
                    }
                    else {
                        NSDictionary *jsonDict = (NSDictionary *)jsonData;
                        
                        NSDictionary *statusDict = jsonDict[@"status"];
                        
                        if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                            
                            [MYProgressHUD showAlertWithMessage:statusDict[@"msg"]];
                        }
                        else {
                            NSDictionary *evaDict = jsonDict[@"data"];
                            
                            NSArray *evaArray = evaDict[@"lists"];
                            
                            if (evaArray.count > 0) {
                                
                                NSMutableArray *mEvaArray = [NSMutableArray array];
                                
                                for (NSDictionary *dict in evaArray) {
                                    EvaluateModel *evaModel = [[EvaluateModel alloc] init];
                                    
                                    evaModel.isNoPhotoShow = YES;
                                    
                                    [evaModel setValueWithDict:dict];
                                    
                                    [mEvaArray addObject:evaModel];
                                }
                                
                                goodsModel.evaluateArray = [mEvaArray copy];
                            }
                        }
                    }
                    
                    goodsModel.shopName = @"不要钱的店";
                    
                    weakSelf.goodsModel = goodsModel;
                    
                    [weakSelf initUI];
                }];
            }
        }
    }];
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(kAppHeight - fScreen(88) - 20 - fScreen(112));
    }];
    
    [self addTitleView];
    
    self.bottomView = [[GoodsDetailBottomView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    self.bottomView.payBlock = ^() {
        OrderShopModel *shopModel = [[OrderShopModel alloc] init];
        shopModel.shopId = weakSelf.goodsModel.shopId;
        shopModel.shopName = weakSelf.goodsModel.shopName;
        shopModel.state = OrderShopState_NoShow;
        shopModel.goodsCount = 3;
        shopModel.goodsAmount = @"2334.4";
        
        OrderModel *orderModel = [[OrderModel alloc] init];
        orderModel.goodsName = @"今天星期五啊,老子明天不上班,不上班啊不上班";
        orderModel.goodsSpecification = @"333";
        orderModel.goodsPrice = @"156.9";
        
        shopModel.goodsArray = @[orderModel, orderModel];
        
        PayOrderDetailController *payVC = [[PayOrderDetailController alloc] initWithPayArray:@[shopModel, shopModel]];
        
        [weakSelf.navigationController pushViewController:payVC animated:YES];
    };
    self.bottomView.toShopBlock = ^() {
        StoreViewController *storeVC = [[StoreViewController alloc] initWithShopId:weakSelf.goodsModel.shopId];
        [weakSelf.navigationController pushViewController:storeVC animated:YES];
    };
    
    self.bottomView.addShopCarBlock = ^ () {
        [MYProgressHUD showAlertWithMessage:@"添加购物车成功~"];
    };
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(fScreen(112));
    }];
}

- (void)addTitleView
{
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@20);
    }];
    
    // backButton
    UIButton *backButton = [self makeBackButton];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(24*2 + 38));
    }];
    
    
    // 更多按钮
    UIButton *moreButton = [[UIButton alloc] init];
    [moreButton setImage:[UIImage imageNamed:@"more_goodsDetail"] forState:UIControlStateNormal];
    [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-fScreen(28));
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(52));
    }];
    
    // 分享
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(moreButton.mas_top);
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(52));
        make.right.equalTo(self.view.mas_right).offset(-fScreen(28 + 52 + 44 - 10));
    }];
}


#pragma mark - Button click
// 分享
- (void)shareButtonClick:(UIButton *)sender
{
    self.goodsMoreView.hidden = YES;
    
    ShareView *shareView = [[ShareView alloc] init];
    [self.view addSubview:shareView];
    shareView.shareModel = self.goodsModel.shareModel;
    shareView.currNaviController = self.navigationController;
}

// 更多
- (void)moreButtonClick:(UIButton *)sender
{
    self.goodsMoreView.hidden = !self.goodsMoreView.hidden;
}

// 去主页
- (void)toMainButtonClick:(UIButton *)sender
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MainViewController class]]) {
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            return;
        }
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[MYTabBarController sharedTabBarController] setSelectedIndex:0];
}

// 帮助
- (void)helpButtonClick:(UIButton *)sender
{

}

- (void)goodsMoreViewHide
{
    self.goodsMoreView.hidden = YES;
}

#pragma mark - HDPageViewController delegate
- (void)pageViewController:(HDPageViewController *)pageController index:(NSInteger)index
{
    self.goodsMoreView.hidden = YES;
    
    if (index != 0) {
        pageController.isShowTitleLine = YES;
    }
    else {
        pageController.isShowTitleLine = NO;
    }
}

#pragma mark - Getter
- (UIView *)goodsMoreView
{
    if (!_goodsMoreView) {
        UIButton *moreCoverView = [[UIButton alloc] init];
        [moreCoverView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.15f]];
        [moreCoverView addTarget:self action:@selector(goodsMoreViewHide) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *moreView = [[UIView alloc] init];
        [moreView setBackgroundColor:[UIColor whiteColor]];
        
        // 首页
        UIButton *toMainButton = [[UIButton alloc] init];
        [toMainButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [toMainButton setImage:[UIImage imageNamed:@"goods_icon_shouye"] forState:UIControlStateNormal];
        [toMainButton setTitle:@"首页" forState:UIControlStateNormal];
        [toMainButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
        [toMainButton addTarget:self action:@selector(toMainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [toMainButton setImageEdgeInsets:UIEdgeInsetsMake(0, -fScreen(10), 0, 0)];
        [toMainButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -fScreen(10))];
        [moreView addSubview:toMainButton];
        [toMainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(moreView);
            make.bottom.equalTo(moreView.mas_centerY);
        }];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:HexColor(0xdadada)];
        [moreView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(moreView);
            make.height.mas_equalTo(fScreen(2));
            make.top.equalTo(toMainButton.mas_bottom);
        }];
        
        // 帮助
        UIButton *helpButton = [[UIButton alloc] init];
        [helpButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [helpButton setImage:[UIImage imageNamed:@"icon_bangzhu"] forState:UIControlStateNormal];
        [helpButton setTitle:@"帮助" forState:UIControlStateNormal];
        [helpButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
        [helpButton addTarget:self action:@selector(helpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [helpButton setImageEdgeInsets:UIEdgeInsetsMake(0, -fScreen(10), 0, 0)];
        [helpButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -fScreen(10))];
        [moreView addSubview:helpButton];
        [helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(moreView);
            make.top.equalTo(moreView.mas_centerY);
        }];
        
        [self.view addSubview:moreCoverView];
        [moreCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.view).offset(fScreen(88) + 20 + 2);
        }];
        
        [moreCoverView addSubview:moreView];
        [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(moreCoverView);
            make.height.mas_equalTo(fScreen(184));
            make.width.mas_equalTo(fScreen(290));
        }];
        
        [moreCoverView setHidden:YES];
        
        _goodsMoreView = moreCoverView;
    }
    return _goodsMoreView;
}

- (HDPageViewController *)pageViewController
{
    if (!_pageViewController) {
        
        NSArray *titles = @[@"商品", @"详情", @"评论"];
        
        __weak typeof(self) weakSelf = self;
        
        GoodsDetailController *detailVC = [[GoodsDetailController alloc] initWithGoodsModel:self.goodsModel bottomView:self.bottomView];
        detailVC.currNavigationController = self.navigationController;
        detailVC.toEvaBlock = ^(){
            [weakSelf.pageViewController moveToIndex:2];
        };
        detailVC.shareBlock = ^() {
            [weakSelf shareButtonClick:nil];
        };
        
        GoodsDetailPhotoController *photoVC = [[GoodsDetailPhotoController alloc] init];
        photoVC.currNavigationController = self.navigationController;
        
        EvaluateController *evaluateVC = [[EvaluateController alloc] init];
        evaluateVC.currNavigationController = self.navigationController;
        
        NSArray *controllers = @[detailVC, photoVC, evaluateVC];
        
        CGSize textSize = [@"宽度" sizeForFontsize:fScreen(28)];
        CGFloat firstTitleMargin = (kAppWidth - (textSize.width*3 + fScreen(60*2)))/2 -6;
        
        _pageViewController = [[HDPageViewController alloc] initWithFrame:CGRectZero
                                                                   titles:titles
                                                              titleMargin:fScreen(60)
                                                              titleHeight:fScreen(88)
                                                         firstTitleMargin:firstTitleMargin
                                                            titleFontSize:fScreen(32)
                                                              controllers:controllers];
        _pageViewController.isShowTitleLine = NO;
        _pageViewController.normalTitleColor = HexColor(0x666666);
        _pageViewController.currTitleColor = HexColor(0xe44a62);
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

@end

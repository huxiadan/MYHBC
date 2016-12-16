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

#import <Masonry.h>

@interface GoodsViewController () <HDPageViewControllerDelegate>

// data
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, strong) GoodsDetailModel *goodsModel;


// UI
@property (nonatomic, strong) HDPageViewController *pageViewController;
@property (nonatomic, strong) GoodsDetailBottomView *bottomView;               // 底部视图


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
    
    [self requestData];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    GoodsDetailModel *model = [[GoodsDetailModel alloc] init];
    model.goodsName = @"[阴阳师手游] 大天狗,妖刀姬,茨木童子,茨木童子,大天狗,妖刀姬,茨木童子,茨木童子";
    model.goodsPrice = @"233.3";
    model.marketPrice = @"333";
    model.commission = @"4.3";
    model.showSpecArray = @[@"颜色: 白色,黑色", @"尺寸: S/M/L"];
    model.specArray = @[@{@"颜色":@[@"白色", @"黑色", @"红色degg", @"隔壁老王之绿色", @"岛国电影之黄色"]},
                        @{@"果实种类":@[@"自然系", @"超人系", @"动物系"]},
                        @{@"果实能力":@[@"响雷果实", @"沙沙果实", @"橡胶果实", @"重力果实", @"飘飘果实", @"透明果实", @"花花果实", @"斑马果实", @"震震果实", @"不死鸟果实", @"钢化膜果实"]}];
    model.evaluateNumber = 9987;
    model.goodEvaluatePre = @"99.7%";
    
    NSMutableArray *evaArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 3; index++) {
        EvaluateModel *evaModel = [[EvaluateModel alloc] init];
        evaModel.userName = @"东莞一条街";
        evaModel.starNumber = 4;
        evaModel.time = @"2016-6-12 14:35";
        evaModel.contentText = @"标准的十五字标准的十五字标准的十五字标准的十五字标准的十五字";
        [evaArray addObject:evaModel];
    }
    
    model.shopName = @"不要钱的店";
    
    model.evaluateArray = [evaArray copy];
    
    self.goodsModel = model;
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
    ShareView *shareView = [[ShareView alloc] init];
    [self.view addSubview:shareView];
}

// 更多
- (void)moreButtonClick:(UIButton *)sender
{}



#pragma mark - HDPageViewController delegate
- (void)pageViewController:(HDPageViewController *)pageController index:(NSInteger)index
{
    if (index != 0) {
        pageController.isShowTitleLine = YES;
    }
    else {
        pageController.isShowTitleLine = NO;
    }
}

#pragma mark - Getter
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

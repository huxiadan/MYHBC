//
//  StoreViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreViewController.h"
#import <Masonry.h>
#import "HDImageTool.h"
#import "ShopModel.h"
#import <UIImageView+WebCache.h>
#import "StoreItemButton.h"
#import "StoreMainViewController.h"
#import "StoreGoodsViewController.h"
#import "StoreCategoryViewController.h"
#import "StoreDetailViewController.h"
#import "SearchViewController.h"

typedef NS_ENUM(NSInteger) {
    ShopMainViewItemTag_Main = 0,       // 首页
    ShopMainViewItemTag_Goods,          // 商品
    ShopMainViewItemTag_Category,       // 分类
    ShopMainViewItemTag_Detail          // 详情
}ShopMainViewItemTag;

@interface StoreViewController () <UIScrollViewDelegate>

// UI
@property (nonatomic, strong) UIView *topView;                  // 顶部搜索返回按钮的视图
@property (nonatomic, strong) UIView *topItemView;              // 顶部选下 item 的视图
@property (nonatomic, strong) UIView *topItemLine;              // item 底部的横线
@property (nonatomic, strong) UIScrollView *contentView;        // 所有内容的视图
@property (nonatomic, strong) UIView *shopInfoView;             // 店铺信息
@property (nonatomic, strong) UIView *shopInfoItemView;         //

@property (nonatomic, strong) UIImageView *bgImageView;         // 高斯模糊的 imageView
@property (nonatomic, strong) UIButton *backButton;             // 返回按钮
@property (nonatomic, strong) UIView *topContentView;           // 顶部变色的视图(返回和搜索的底部图)

@property (nonatomic, strong) UIView *moduleView;               // 每个不同模块内容的视图

@property (nonatomic, assign) NSInteger currItemTag;            // 当前的item的类型


// Data
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, strong) ShopModel *shopModel;

@property (nonatomic, assign) CGFloat contentHeight;            // 内容的高度
@property (nonatomic, assign) CGFloat offsetHeight;             // 非首页的偏移量

@end

@implementation StoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
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

- (void)dealloc
{
    DLog(@"StoreViewController dealloc");
}

- (instancetype)initWithShopId:(NSString *)shopId
{
    if (self = [super init]) {
        self.shopId = shopId;
    }
    return self;
}

- (void)requestData
{
    ShopModel *shopModel = [[ShopModel alloc] init];
    
    shopModel.shopName = @"赵铁柱he李小花富土康专营店";
    shopModel.shopIconURL = @"http://img5.duitang.com/uploads/item/201410/04/20141004175033_5dcPH.thumb.700_0.jpeg";
    shopModel.iconType = ShopIconType_Brand;
    shopModel.notice = @"满288送一个失恋的张全蛋";
    shopModel.bannerArray = @[@"http://pic.58pic.com/58pic/17/37/33/29A58PICGX5_1024.jpg", @"http://pic.90sjimg.com/back_pic/00/04/27/49/d729357f0fdf8eaec3433cb495949ede.jpg", @"http://pic2.ooopic.com/12/80/79/89bOOOPICd2_1024.jpg"];
    
    NSMutableArray *tmpGroupArray = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger index = 0; index < 3; index++) {
        BaiXianBaiPinModel *model = [[BaiXianBaiPinModel alloc] init];
        model.goodsName = @"李铁柱的 C 盘";
        model.goodsSpec = @"4G/部";
        model.price = @"987";
        model.personCount = 5;
        model.marketPrice = @"4000";
        if (index == 0) {
            model.type = BaiXianBaiPinCellType_Normal;
            model.commissionTitle = @"最多可赚";
            model.commissionContent = @"fjeljgalsj";
        }
        else if (index == 1) {
            model.type= BaiXianBaiPinCellType_LimitTime;
            model.countDownTime = 29877;
        }
        else {
            model.type = BaiXianBaiPinCellType_MasterFree;
        }
        [tmpGroupArray addObject:model];
    }
    shopModel.groupArray = [tmpGroupArray copy];
    
    NSMutableArray *tmpRecArray = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger index = 0; index < 6; index++) {
        ShopRecommendModel *model = [[ShopRecommendModel alloc] init];
        model.goodsPrice = @"241";
        model.saleNumber = 999;
        [tmpRecArray addObject:model];
    }
    shopModel.recommendArray = [tmpRecArray copy];
    
    NSMutableArray *tmpHotArray = [NSMutableArray arrayWithCapacity:7];
    for (NSInteger index = 0; index < 7; index++) {
        GoodsModel *model = [[GoodsModel alloc] init];
        model.goodsName = @"李小花的闺蜜";
        model.goodsPrice = @"50";
        model.marketPrice = @"88";
        model.goodsImageURL = @"http://img1.ali213.net/picfile/News/2014/01/16/pm/584_20140116135204166.jpg";
        [tmpHotArray addObject:model];
    }
    shopModel.hotArray = [tmpHotArray copy];
    
    self.shopModel = shopModel;
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 内容视图
    if (!self.contentView) {
        UIScrollView *contentView = [[UIScrollView alloc] init];
        [contentView setBackgroundColor:viewControllerBgColor];
        [contentView setDelegate:self];
        [contentView setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
        self.contentView = contentView;
    }
    
    // 顶部视图
    if (!self.topView) {
        UIView *topView = [self makeTopView];
        [self.view addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.view);
            make.height.mas_equalTo(fScreen(88) + 20);
        }];
        self.topView = topView;
    }
    
    if (!self.topItemView) {
        self.topItemView = [self makeTopItemView];
        [self.view addSubview:self.topItemView];
        [self.topItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_bottom);
            make.left.right.equalTo(self.topView);
            make.height.mas_equalTo(fScreen(88));
        }];
        [self.topItemView setAlpha:0];
    }
    
    if (!self.shopInfoView) {
        UIView *shopInfoView = [self makeShopInfoView];
        [self.contentView addSubview:shopInfoView];
        [shopInfoView setFrame:CGRectMake(0, 0, kAppWidth, fScreen(565))];
        self.shopInfoView = shopInfoView;
        
        self.contentHeight += CGRectGetHeight(self.shopInfoView.frame);
    }
    
    if (!self.moduleView) {
        self.moduleView = [self makeModuleView];
        // 默认是首页.先添加首页
        [self moduleFrom:ShopMainViewItemTag_Main to:ShopMainViewItemTag_Main];
        
        CGFloat height = ((StoreMainViewController *)[self.childViewControllers objectAtIndex:ShopMainViewItemTag_Main]).height;
        [self.moduleView setFrame:CGRectMake(0, self.contentHeight, kAppWidth, height)];
        
        self.contentHeight += height;
        
        [self.contentView addSubview:self.moduleView];
    }
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
    
    [self.contentView setContentSize:CGSizeMake(0, contentHeight)];
}

- (void)moduleFrom:(ShopMainViewItemTag)from to:(ShopMainViewItemTag)to
{
    // 移除旧的
    UIViewController *oldVC = [self.childViewControllers objectAtIndex:from];
    [oldVC.view removeFromSuperview];
    
    // 添加新的
    UIViewController *newVC = [self.childViewControllers objectAtIndex:to];
    [self.moduleView addSubview:newVC.view];
    [newVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.moduleView);
    }];
}

#pragma mark - makeView

- (UIView *)makeTopItemView
{
    UIView *itemView = [[UIView alloc] init];
    [itemView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *titleArray = @[@"首页", @"商品", @"分类", @"详情"];
    CGFloat buttonWidth = kAppWidth/4;
    
    for (NSInteger index = 0; index < 4; index++) {
        UIButton *button = [[UIButton alloc] init];
        [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [button setTitleColor:HexColor(0xe44a62) forState:UIControlStateSelected];
        [button setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(buttonWidth * index, 0, buttonWidth, fScreen(88))];
        [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:index];
        [itemView addSubview:button];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:HexColor(0xe44a62)];
    [lineView setFrame:CGRectMake((buttonWidth - fScreen(128))/2, fScreen(88) - 2, fScreen(128), 2)];
    [itemView addSubview:lineView];
    self.topItemLine = lineView;

    return itemView;
}

- (UIView *)makeModuleView
{
    UIView *contentView = [[UIView alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
    // 首页
    StoreMainViewController *mainVC = [[StoreMainViewController alloc] initWithShopModel:self.shopModel];
    mainVC.currNavigationController = self.navigationController;
    [self addChildViewController:mainVC];
    
    // 商品
    StoreGoodsViewController *goodsVC = [[StoreGoodsViewController alloc] initWithShopId:self.shopModel.shopId mainView:self.view];
    goodsVC.scrollBlock = ^() {
        weakSelf.contentView.scrollEnabled = YES;
    };
    
    goodsVC.currNavigationController = self.navigationController;
    [self addChildViewController:goodsVC];
    
    // 分类
    StoreCategoryViewController *categoryVC = [[StoreCategoryViewController alloc] init];
    categoryVC.currNavigationController = self.navigationController;
    categoryVC.scrollBlock = ^() {
        weakSelf.contentView.scrollEnabled = YES;
    };
//    categoryVC.jumpBlock = ^(NSString *title) {
//        
//        [weakSelf moduleFrom:ShopMainViewItemTag_Category to:ShopMainViewItemTag_Goods];
//        
//        for (UIView *subView in self.topItemView.subviews) {
//            if ([subView isKindOfClass:[UIButton class]]) {
//                
//                UIButton *button = (UIButton *)subView;
//                
//                if (button.tag == ShopMainViewItemTag_Goods) {
//                    [weakSelf itemButtonClick:button];
//                    return;
//                }
//            }
//        }
//    };
    [self addChildViewController:categoryVC];
    
    // 详情
    StoreDetailViewController *detailVC = [[StoreDetailViewController alloc] init];
    detailVC.currNavigationController = self.navigationController;
    [self addChildViewController:detailVC];
    
    return contentView;
}

- (UIView *)makeShopInfoView
{
    UIView *infoView = [[UIView alloc] init];
    
    // 背景
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.contentMode = UIViewContentModeScaleToFill;
    [bgImageView setBackgroundColor:RGB(30, 144, 255)];
    self.bgImageView = bgImageView;
    
    [infoView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(infoView);
    }];
    __weak typeof(UIImageView *) weakBgImageView = bgImageView;
    
    // 店铺头像
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView.layer setCornerRadius:fScreen(128/2)];
    [iconImageView.layer setMasksToBounds:YES];
    [infoView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView).offset(fScreen(88 + 58) + 20);
        make.left.equalTo(infoView).offset(fScreen(30));
        make.height.mas_equalTo(fScreen(128));
        make.width.mas_equalTo(fScreen(128));
    }];
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.shopModel.shopIconURL] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [weakBgImageView setImage:image];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *gasImage = [HDImageTool makeBlurImage:image withBlurNumber:3.0];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakBgImageView setBackgroundColor:viewControllerBgColor];
                    [weakBgImageView setImage:gasImage];
                });
            });
        }
    }];
    
    // 分享
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [infoView addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(infoView).offset(-fScreen(58));
        make.height.mas_equalTo(fScreen(72));
        make.width.mas_equalTo(fScreen(40));
        make.centerY.equalTo(iconImageView.mas_centerY);
    }];
    
    // 收藏
    UIButton *collectButton = [[UIButton alloc] init];
    [collectButton setImage:[UIImage imageNamed:@"icon_collect_n"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"icon_collect-_f"] forState:UIControlStateSelected];
    [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.shopModel.isCollected) {
        collectButton.selected = YES;
    }
    
    [infoView addSubview:collectButton];
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left).offset(-fScreen(76));
        make.top.height.with.equalTo(shareButton);
    }];
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [nameLabel setTextColor:[UIColor whiteColor]];
    [nameLabel setText:self.shopModel.shopName];
    [infoView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(iconImageView.mas_centerY);
        make.left.equalTo(iconImageView.mas_right).offset(fScreen(10));
        make.height.mas_equalTo(fScreen(32));
        make.right.equalTo(collectButton.mas_left).offset(-fScreen(10));
    }];
    
    // 品牌专卖
    NSString *iconTypeImageName;
    switch (self.shopModel.iconType) {
        case ShopIconType_None:
        default:
            iconTypeImageName = @"";
            break;
        case ShopIconType_Brand:        // 品牌
            iconTypeImageName = @"lab_brand";
            break;
        case ShopIconType_Official:     // 旗舰
            iconTypeImageName = @"lab_offic";
            break;
        case ShopIconType_Personal:     // 个人
            iconTypeImageName = @"lab_gr";
            break;
        case ShopIconType_Company:      // 企业
            iconTypeImageName = @"lab_qiye";
            break;
    }
    UIImageView *brandIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconTypeImageName]];
    [brandIcon setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    [infoView addSubview:brandIcon];
    [brandIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel);
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(20));
        
    }];
    
    
    // 切换按钮
    UIView *itemView = [[UIView alloc] init];
    [itemView setBackgroundColor:[UIColor whiteColor]];
    [infoView addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(fScreen(58));
        make.bottom.equalTo(infoView).offset(-fScreen(20));
        make.left.equalTo(infoView).offset(fScreen(30));
        make.right.equalTo(infoView).offset(-fScreen(30));
    }];
    self.shopInfoItemView = itemView;
    
    NSArray *imageArray = @[@"icon_shouye_n", @"icon_shangpin_n", @"icon_fenlei-_n", @"icon_xiangqing_n",
                            @"icon_shouye", @"icon_shangpin_f", @"icon_fenlei-_f", @"icon_xiangqing_f"];
    NSArray *titleArray = @[@"首页", @"商品", @"分类", @"详情"];
    
    CGFloat x = (kAppWidth - fScreen(30*2) - fScreen((54)*4) - fScreen(124*3))/2;
    StoreItemButton *adjustItem;
    
    for (NSInteger index = 0; index < 4; index++) {
        StoreItemButton *itemButton = [[StoreItemButton alloc] initWithTitle:[titleArray objectAtIndex:index] imageName:[imageArray objectAtIndex:index] heightlightImageName:[imageArray objectAtIndex:index + 4] target:self action:@selector(itemButtonClick:)];

        [itemButton setTag:index];

        if (index == 0) {
            itemButton.selected = YES;
            self.currItemTag = itemButton.tag;
            adjustItem = itemButton;
        }
        
        [itemView addSubview:itemButton];
        [itemButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(x + index*fScreen(54 + 124 - 20));
            make.height.mas_equalTo(itemButton.height);
            make.width.mas_equalTo(fScreen(54 + 20));
            if (index == 1) {
                make.bottom.equalTo(adjustItem);
            }
            else {
                make.centerY.equalTo(itemView);
            }
        }];
    }
    
    return infoView;
}

- (UIView *)makeTopView
{
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    
    UIView *topContentView = [[UIView alloc] init];
    [topView addSubview:topContentView];
    [topContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(topView);
        make.height.mas_equalTo(fScreen(88));
    }];
    self.topContentView = topContentView;
    
    UIButton *backButton = [self makeBackButton];
    self.backButton = backButton;
    [backButton setImage:[UIImage imageNamed:@"icon_back_w"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topContentView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topContentView.mas_left);
        make.centerY.equalTo(topContentView.mas_centerY);
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(28*2 + 38));
    }];
    
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setBackgroundColor:[UIColor whiteColor]];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [searchButton setImage:[UIImage imageNamed:@"icon_search-nei"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索店铺内商品" forState:UIControlStateNormal];
    [searchButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [searchButton.layer setCornerRadius:fScreen(8)];
    [searchButton.layer setBorderColor:HexColor(0xdadada).CGColor];
    [searchButton.layer setBorderWidth:1.f];
    [searchButton.layer setMasksToBounds:YES];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).offset(fScreen(2));
        make.right.equalTo(topContentView.mas_right).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(58));
        make.centerY.equalTo(backButton.mas_centerY);
    }];
    
    return topView;
}


#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    
    [self scrollViewDeal:scrollView offset:offset];
}

// 滚动逻辑处理
- (void)scrollViewDeal:(UIScrollView *)scrollView offset:(CGPoint)offset
{
    if (offset.y < 0) {
        CGRect bgFrame = self.bgImageView.frame;
        
        int change = [[NSNumber numberWithFloat:-offset.y] intValue];
        
        bgFrame.origin.x = -change;
        bgFrame.origin.y = -change * 2;
        bgFrame.size.height = fScreen(565) + change * 2;
        bgFrame.size.width = kAppWidth + change * 2;
        
        [self.bgImageView setFrame:bgFrame];
    }
    else {
        CGFloat maxHeight = CGRectGetMaxY(self.shopInfoView.frame) - fScreen(88);
        
        if (self.currItemTag == ShopMainViewItemTag_Main) {
            
            // 防止从商品/分类切换到其他两个(首页/详情)导致不能滑动
            [self.contentView setScrollEnabled:YES];
            
            // 公告高度
            if (self.shopModel.notice.length > 0) {
                maxHeight += fScreen(88);
            }
            // 轮播图高度
            maxHeight += fScreen(20 + 435);
            
            if (maxHeight > offset.y && offset.y > fScreen(20)) {
                
                if (CGRectGetMaxY(self.shopInfoView.frame) < offset.y) {
                    CGFloat newAlpha = (offset.y - CGRectGetHeight(self.shopInfoView.frame) + fScreen(88))/ fScreen(435) + 0.1;
                    [self.topItemView setAlpha:newAlpha];
                    [self.topView setBackgroundColor:[UIColor colorWithWhite:1 alpha:newAlpha]];
                    [self.topContentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:newAlpha]];
                }
                else {
                    [self.topItemView setAlpha:0];
                    
                    CGFloat alpha = offset.y/maxHeight;
                    [self.topView setBackgroundColor:[UIColor colorWithWhite:1 alpha:alpha]];
                    [self.topContentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:alpha]];
                    [self.backButton setImage:[UIImage imageNamed:@"jiantou-(1)"] forState:UIControlStateNormal];
                }
            }
            else if ((0 <= offset.y && offset.y <= fScreen(20)) || offset.y < 0) {
                [self.topItemView setAlpha:0];
                
                [self.topView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
                [self.topContentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:0]];
                [self.backButton setImage:[UIImage imageNamed:@"icon_back_w"] forState:UIControlStateNormal];
            }
            else {
                [self.topView setAlpha:1];
                [self.topContentView setAlpha:1];
                [self.topItemView setAlpha:1];
            }
        }
        else {
            // topView 到 shopInfoView 间的距离
            if (offset.y > CGRectGetHeight(self.topView.frame) + fScreen(88) && offset.y <= CGRectGetHeight(self.shopInfoView.frame)) {
                CGFloat y = CGRectGetHeight(self.shopInfoView.frame) - CGRectGetHeight(self.topView.frame) - fScreen(88);
                CGFloat alpha = (offset.y)/y;
                [self.topItemView setAlpha:alpha];
                [self.topView setBackgroundColor:[UIColor colorWithWhite:1 alpha:alpha]];
                [self.topContentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:alpha]];
                [self.backButton setImage:[UIImage imageNamed:@"jiantou-(1)"] forState:UIControlStateNormal];
                
            }
            // 小于20 的距离
            else if (offset.y < fScreen(20)) {
                [self.topItemView setAlpha:0];
                [self.topView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
                [self.topContentView setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:0]];
                [self.backButton setImage:[UIImage imageNamed:@"icon_back_w"] forState:UIControlStateNormal];
            }
            // 超过 shopInfoView
            else if (offset.y > CGRectGetHeight(self.shopInfoView.frame) - CGRectGetHeight(self.topView.frame) - fScreen(88)){
                
                // 固定滚动
                if (!scrollView.isDragging && !scrollView.isDecelerating) {
                    [scrollView setContentOffset:CGPointMake(8, self.offsetHeight)];
                }
            }
            
            // 设置滚动(商品/分类)
            if (offset.y >= CGRectGetHeight(self.shopInfoView.frame) - CGRectGetHeight(self.topView.frame) - fScreen(88)) {
                if (self.currItemTag == ShopMainViewItemTag_Goods) {
                    StoreGoodsViewController *goodsVc = (StoreGoodsViewController *)[self.childViewControllers objectAtIndex:1];
                    [goodsVc setCanScroll];
                    
                    // 只视图可滚动时,主视图不可滚动
                    [self.contentView setScrollEnabled:NO];
                }
                else if (self.currItemTag == ShopMainViewItemTag_Category) {
                    StoreCategoryViewController *categoryVC = (StoreCategoryViewController *)[self.childViewControllers objectAtIndex:2];
                    [categoryVC setCanScroll];
                    [self.contentView setScrollEnabled:NO];
                }
                else {
                    // 防止切换到其他两个(首页/详情)导致不能滑动
                    [self.contentView setScrollEnabled:YES];
                }
            }
            else{
                if (self.currItemTag == ShopMainViewItemTag_Goods) {
                    StoreGoodsViewController *goodsVc = (StoreGoodsViewController *)[self.childViewControllers objectAtIndex:1];
                    [goodsVc setCanNotScroll];
                }
                else if (self.currItemTag == ShopMainViewItemTag_Category) {
                    StoreCategoryViewController *categoryVC = (StoreCategoryViewController *)[self.childViewControllers objectAtIndex:2];
                    [categoryVC setCanNotScroll];
                }
            }
        }
    }

}


#pragma mark - button click
- (void)searchButtonClick:(UIButton *)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithShopId:self.shopId];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)shareButtonClick:(UIButton *)sender
{}

- (void)collectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    // 请求接口
}

- (void)itemButtonClick:(UIButton *)sender
{
    // 逻辑控制:动中不允许切换,避免因此导致 scrollView 的状态设置不正确
    if (self.contentView.isDragging || self.contentView.isDecelerating) {
        return;
    }
    if (sender.alpha != 1) {
        return;
    }
    
    if (self.currItemTag == sender.tag) {
        return;
    }
    
    CGFloat itemWidth = kAppWidth/4;
    CGFloat lineWidth = fScreen(128);
    // topItemView 底部横线的 x 坐标
    CGFloat x = (itemWidth - lineWidth)/2;
    
    switch (sender.tag) {
        case ShopMainViewItemTag_Main:
        default:
            
            break;
        case ShopMainViewItemTag_Goods:
            x += itemWidth;
            break;
        case ShopMainViewItemTag_Category:
            x += itemWidth * 2;
            break;
        case ShopMainViewItemTag_Detail:
            x += itemWidth * 3;
            break;
    }
    [self.topItemLine setFrame:CGRectMake(x, fScreen(88) - 2, lineWidth, 2)];
    
    // 底部视图切换
    [self moduleFrom:self.currItemTag to:sender.tag];

    // 改变 tag
    NSInteger newTag = sender.tag;
    NSInteger oldTag = self.currItemTag;
    self.currItemTag = newTag;
    
    if (newTag != oldTag) {
        for (StoreItemButton *button in self.shopInfoItemView.subviews) {
            if (button.tag == oldTag) {
                button.selected = NO;
            }
            else if (button.tag == newTag) {
                button.selected = YES;
            }
        }
        
        for (UIView *subView in self.topItemView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subView;
                
                if (button.tag == oldTag) {
                    button.selected = NO;
                }
                else if (button.tag == newTag) {
                    button.selected = YES;
                }
            }
        }
    }
    
    // 底部视图切换后的逻辑处理
    StoreModuleBaseViewController *toVC = [self.childViewControllers objectAtIndex:sender.tag];
    CGRect moduleViewFrame = self.moduleView.frame;
    moduleViewFrame.size.height = toVC.height;
    
    CGFloat newContentHeight = CGRectGetMaxY(self.shopInfoView.frame) + toVC.height;
    
    if (sender.tag == ShopMainViewItemTag_Goods || sender.tag == ShopMainViewItemTag_Category) {
        newContentHeight = kAppHeight + self.offsetHeight + fScreen(6);
        
        moduleViewFrame.size.height = kAppHeight - CGRectGetMaxY(self.topItemView.frame);
        [self.moduleView setFrame:moduleViewFrame];
        
        if (self.contentView.contentOffset.y == self.offsetHeight) {
            [self.contentView setScrollEnabled:YES];
        }
    }
    else if (sender.tag == ShopMainViewItemTag_Main) {
        moduleViewFrame.size.height = toVC.height;
        [self.moduleView setFrame:moduleViewFrame];
        
        // 顶部视图要特殊处理
        CGPoint offset = self.contentView.contentOffset;
        
        // 公告高度
        if (self.shopModel.notice.length > 0) {
            offset.y += fScreen(88);
        }
        // 轮播图高度
        offset.y += fScreen(20 + 435);
        
        [self.contentView setContentOffset:offset];
        
        // 执行滚动的逻辑
        [self scrollViewDeal:self.contentView offset:offset];
    }
    
    if (newContentHeight > kAppHeight) {
        self.contentHeight = newContentHeight;
    }
    else {
        self.contentHeight = kAppHeight + fScreen(20);
    }
    
}

- (void)backButtonClick:(UIButton *)sender
{
    [super backButtonClick:sender];
}

#pragma mark - Getter
- (CGFloat)offsetHeight
{
    if (_offsetHeight == 0) {
        _offsetHeight = CGRectGetHeight(self.shopInfoView.frame) - CGRectGetHeight(self.topView.frame) - fScreen(88);
    }
    return _offsetHeight;
}

@end

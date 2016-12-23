//
//  StoreMainViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreMainViewController.h"
#import "ShopGroupBuyView.h"
#import "ShopMasterRecommView.h"
#import "ShopHotRecommView.h"
#import "ShopModel.h"
#import <SDCycleScrollView.h>
#import <Masonry.h>
#import "GoodsViewController.h"

@interface StoreMainViewController () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;        // 所有内容的视图
@property (nonatomic, strong) UIView *noticeView;               // 公告
@property (nonatomic, strong) SDCycleScrollView *bannerView;    // 轮播图
@property (nonatomic, strong) ShopGroupBuyView *groupbuyView;   // 拼团
@property (nonatomic, strong) ShopMasterRecommView *masterRecView;  // 店长推荐
@property (nonatomic, strong) ShopHotRecommView *hotRecView;    // 热门推荐
@property (nonatomic, strong) UIButton *allGoodsButton;         // 查看全部


@property (nonatomic, strong) ShopModel *shopModel;
@property (nonatomic, assign) CGFloat contentHeight;

//@property (nonatomic, assign) CGFloat height;

@end

@implementation StoreMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithShopModel:(ShopModel *)shopModel
{
    if (self = [super init]) {
        self.shopModel = shopModel;
    }
    return self;
}

- (void)initUI
{
    UIScrollView *contentView = [[UIScrollView alloc] init];
    [contentView setBackgroundColor:viewControllerBgColor];
    [contentView setScrollEnabled:NO];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    self.contentView = contentView;
    
    // 公告
    if (!self.noticeView) {
        if (self.shopModel.notice.length > 0) {
            UIView *noticeView = [self makeNoticeView];
            self.noticeView = noticeView;
            [self.contentView addSubview:noticeView];
            [noticeView setFrame:CGRectMake(0, 0, kAppWidth, fScreen(88))];
            
            self.contentHeight += CGRectGetHeight(self.noticeView.frame);
        }
        else {
            self.noticeView = [[UIView alloc] init];
            [self.contentView addSubview:self.noticeView];
            [self.noticeView setFrame:CGRectZero];
        }
    }
    
    // 轮播图
    if (!self.bannerView) {
        SDCycleScrollView *bannerView = [self makeBannerView];
        [self.contentView addSubview:bannerView];
        self.bannerView = bannerView;
        
        self.contentHeight += fScreen(20) + CGRectGetHeight(self.bannerView.frame);
    }
    
    __weak typeof(self ) weakSelf = self;
    
    // 拼团
    if (!self.groupbuyView) {
        if (self.shopModel.groupArray.count > 0) {
            UIView *groupHeader = [self makeSessionHeaderWithTitle:@"火热开团"];
            [self.contentView addSubview:groupHeader];
            [groupHeader setFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kAppWidth, fScreen(65))];
            
            self.groupbuyView = [[ShopGroupBuyView alloc] initWithGroupArray:self.shopModel.groupArray];
            self.groupbuyView.clickBlock = ^(NSString *goodsId) {
                GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:goodsId];
                [weakSelf.navigationController pushViewController:goodsVC animated:YES];
            };
            
            [self.contentView addSubview:self.groupbuyView];
            [self.groupbuyView setFrame:CGRectMake(0, CGRectGetMaxY(groupHeader.frame), kAppWidth, fScreen(300) * self.shopModel.groupArray.count)];
            
            self.contentHeight += CGRectGetHeight(groupHeader.frame) + CGRectGetHeight(self.groupbuyView.frame);
        }
        else {
            self.groupbuyView = (ShopGroupBuyView *)[[UIView alloc] init];
            [self.groupbuyView setFrame:CGRectMake(0, CGRectGetMaxY(self.bannerView.frame), kAppWidth, 0)];
            [self.contentView addSubview:self.groupbuyView];
        }
    }
    
    // 店长力荐
    if (!self.masterRecView) {
        if (self.shopModel.recommendArray.count > 0) {
            UIView *recommendHeader = [self makeSessionHeaderWithTitle:@"店长力荐"];
            [self.contentView addSubview:recommendHeader];
            if (self.shopModel.groupArray.count == 0) {
                [recommendHeader setFrame:CGRectMake(0, CGRectGetMaxY(self.groupbuyView.frame), kAppWidth, fScreen(65))];
            }
            else {
                [recommendHeader setFrame:CGRectMake(0, CGRectGetMaxY(self.groupbuyView.frame) - fScreen(20), kAppWidth, fScreen(65))];
            }
            
            self.masterRecView = [[ShopMasterRecommView alloc] initWithRecommendArray:self.shopModel.recommendArray];
            self.masterRecView.clickBlock = ^(NSString *goodsId) {
                GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:goodsId];
                [weakSelf.navigationController pushViewController:goodsVC animated:YES];
            };
            
            [self.contentView addSubview:self.masterRecView];
            NSInteger row = [[NSNumber numberWithFloat:self.shopModel.recommendArray.count/3] integerValue];
            if (self.shopModel.recommendArray.count%3 != 0) {
                row += 1;
            }
            [self.masterRecView setFrame:CGRectMake(0, CGRectGetMaxY(recommendHeader.frame), kAppWidth, (fScreen(250 + 20 + 48 + 20 + 24 + 20))*row)];
            
            self.contentHeight += CGRectGetHeight(recommendHeader.frame) + CGRectGetHeight(self.masterRecView.frame);
        }
        else {
            self.masterRecView = (ShopMasterRecommView *)[[UIView alloc] init];
            [self.contentView addSubview:self.masterRecView];
            [self.masterRecView setFrame:CGRectMake(0, CGRectGetMaxY(self.groupbuyView.frame), kAppWidth, 0)];
        }
    }
    
    // 热门推荐
    if (!self.hotRecView) {
        if (self.shopModel.hotArray.count > 0) {
            UIView *hotHeader = [self makeSessionHeaderWithTitle:@"热门推荐"];
            [self.contentView addSubview:hotHeader];
            [hotHeader setFrame:CGRectMake(0, CGRectGetMaxY(self.masterRecView.frame), kAppWidth, fScreen(65))];
            
            self.hotRecView = [[ShopHotRecommView alloc] initWithHotArray:self.shopModel.hotArray];
            self.hotRecView.clickBlock = ^(NSString *goodsId) {
                GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:goodsId];
                [weakSelf.navigationController pushViewController:goodsVC animated:YES];
            };
            
            [self.contentView addSubview:self.hotRecView];
            
            NSInteger row = [[NSNumber numberWithFloat:self.shopModel.hotArray.count/2] integerValue];
            if (self.shopModel.hotArray.count%2 != 0) {
                row += 1;
            }
            [self.hotRecView setFrame:CGRectMake(0, CGRectGetMaxY(hotHeader.frame), kAppWidth, fScreen(468 + 20)*row - fScreen(20))];
            
            self.contentHeight += CGRectGetHeight(hotHeader.frame) + CGRectGetHeight(self.hotRecView.frame);
        }
        else {
            self.hotRecView = [(ShopHotRecommView *)[UIView alloc] init];
            [self.contentView addSubview:self.hotRecView];
            [self.hotRecView setFrame:CGRectMake(0, CGRectGetMaxY(self.masterRecView.frame), kAppWidth, 0)];
        }
    }
    
    // 查看所有好货
    if (!self.allGoodsButton) {
        UIButton *allGoodsButton = [[UIButton alloc] init];
        [allGoodsButton setBackgroundColor:[UIColor whiteColor]];
        [allGoodsButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [allGoodsButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
        [allGoodsButton setTitle:@"查看所有好货" forState:UIControlStateNormal];
        [allGoodsButton addTarget:self action:@selector(allGoodsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:allGoodsButton];
        [allGoodsButton setFrame:CGRectMake(0, self.contentHeight + fScreen(20), kAppWidth, fScreen(88))];
        
        [self.contentView setContentSize:CGSizeMake(0, CGRectGetMaxY(allGoodsButton.frame) + fScreen(20))];
        self.allGoodsButton = allGoodsButton;
        
        self.contentHeight += CGRectGetHeight(allGoodsButton.frame) + fScreen(20);
    }
    
    self.height = self.contentHeight;
}

- (void)setContentHeight:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
    
    [self.contentView setContentSize:CGSizeMake(0, contentHeight)];
}

#pragma mark - make View

// 火热开团/店长推荐/热门推荐
- (UIView *)makeSessionHeaderWithTitle:(NSString *)title
{
    UIView *header = [[UIView alloc] init];
    [header setBackgroundColor:viewControllerBgColor];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [label setTextColor:HexColor(0x666666)];
    [label setText:title];
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header);
        make.centerY.equalTo(header);
        make.height.mas_equalTo(fScreen(32));
        //        CGSize textSize = [label.text sizeForFontsize:fScreen(32)];
        make.width.mas_equalTo(fScreen(32*4) + 2);
    }];
    
    UIView *leftLine = [[UIView alloc] init];
    [leftLine setBackgroundColor:RGB(218, 218, 218)];
    [header addSubview:leftLine];
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header).offset(fScreen(28));
        make.right.equalTo(label.mas_left).offset(-fScreen(28));
        make.height.mas_equalTo(1);
        make.centerY.equalTo(header);
    }];
    
    UIView *rightLine = [[UIView alloc] init];
    [rightLine setBackgroundColor:leftLine.backgroundColor];
    [header addSubview:rightLine];
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(header).offset(fScreen(-28));
        make.left.equalTo(label.mas_right).offset(fScreen(28));
        make.centerY.height.equalTo(leftLine);
    }];
    return header;
}

- (SDCycleScrollView *)makeBannerView
{
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.noticeView.frame) + fScreen(20), kAppWidth, fScreen(435));
    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:frame delegate:self placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    
    banner.imageURLStringsGroup = self.shopModel.bannerArray;
    
    return banner;
}


- (UIView *)makeNoticeView
{
    UIView *noticeView = [[UIView alloc] init];
    [noticeView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *icon = [[UIImageView alloc] init];
    [icon setImage:[UIImage imageNamed:@"icon_gonggao"]];
    [noticeView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noticeView).offset(fScreen(30));
        make.centerY.equalTo(noticeView);
        make.height.mas_equalTo(fScreen(40));
        make.width.mas_equalTo(fScreen(96));
    }];
    
    UILabel *moreLabel = [[UILabel alloc] init];
    [moreLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [moreLabel setText:@"查看更多 >"];
    [moreLabel setTextColor:HexColor(0x999999)];
    [noticeView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(noticeView).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(20));
        make.width.mas_equalTo(fScreen(105));
        make.centerY.equalTo(noticeView);
    }];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    [noticeLabel setText:self.shopModel.notice];
    [noticeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [noticeLabel setTextColor:HexColor(0x666666)];
    [noticeView addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(fScreen(30));
        make.centerY.equalTo(icon);
        make.height.mas_equalTo(fScreen(24));
        make.right.equalTo(moreLabel.mas_left).offset(-fScreen(20));
    }];
    
    return noticeView;
}

#pragma mark - button click
// 查看所有好货
- (void)allGoodsButtonClick:(UIButton *)sender
{
    
}

@end

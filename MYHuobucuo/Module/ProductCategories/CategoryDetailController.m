//
//  CategoryDetailController.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryDetailController.h"
#import <Masonry.h>
#import "HDPageViewController.h"
#import "CategoryDetailView.h"
#import "SearchViewController.h"
#import "GoodsViewController.h"

@interface CategoryDetailController ()

@property (nonatomic, copy) NSString *controllerTitle;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) HDPageViewController *pageController;

@end

@implementation CategoryDetailController

- (instancetype)initWithTitle:(NSString *)controllerTitle
{
    if (self = [super init]) {
        self.controllerTitle = controllerTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSArray *titleArray = @[@"杨桃", @"柚子", @"苹果", @"西红柿", @"哈密瓜", @"香蕉", @"芭乐", @"芒果"];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:14];
    for (NSInteger index = 0; index < 14; index++) {
        GoodsModel *model = [[GoodsModel alloc] init];
        model.goodsName = @"平和红心蜜柚  ";//平和红心蜜柚5斤两颗装adfedfdffff
        model.goodsPrice = @"22.8";
        model.marketPrice = @"32.9";
        [tmpArray addObject:model];
    }
    
    NSMutableArray *controllerArray = [NSMutableArray arrayWithCapacity:8];
    for (NSInteger index = 0; index < 8; index++) {
        UIViewController *controller = [[UIViewController alloc] init];
        CategoryDetailView *view = [self createDetailViewWithTitle:@"美容瘦身好口感" dataArray:[tmpArray copy]];
        [controller.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(controller.view.mas_top);
            make.bottom.equalTo(controller.view.mas_bottom).offset(-49);
            make.left.equalTo(controller.view.mas_left).offset(fScreen(30));
            make.right.equalTo(controller.view.mas_right).offset(-fScreen(30));
        }];
        [controllerArray addObject:controller];
    }
    
    self.pageController = [[HDPageViewController alloc] initWithFrame:CGRectZero titles:titleArray titleMargin:fScreen(78) titleHeight:0 firstTitleMargin:fScreen(48) titleFontSize:fScreen(28) controllers:[controllerArray copy]];
    
    self.pageController.TitleLineColor = HexColor(0xe44a62);
    self.pageController.currTitleColor = HexColor(0xe44a62);
    self.pageController.normalTitleColor = HexColor(0x999999);
    [self.pageController.view setBackgroundColor:viewControllerBgColor];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 返回顶部的 button
    UIButton *toTopButton = [[UIButton alloc] init];
    [toTopButton setImage:[UIImage imageNamed:@"icon_top"] forState:UIControlStateNormal];
    [toTopButton addTarget:self action:@selector(toTopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toTopButton];
    [toTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-fScreen(102 - 40));
        make.width.mas_equalTo(fScreen(68 + 40*2));
        make.height.mas_equalTo(fScreen(68 + 40*2));
    }];
}

- (CategoryDetailView *)createDetailViewWithTitle:(NSString *)title dataArray:(NSArray *)dataArray
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = fScreen(20);
    layout.minimumInteritemSpacing = fScreen(20);
    CGFloat width = kAppWidth - 2*fScreen(30);
    layout.headerReferenceSize = CGSizeMake(width, fScreen(96));
    if ([HDDeviceInfo isIPhone5Size] || [HDDeviceInfo isIPhone4Size]) {
        layout.itemSize = CGSizeMake((width - fScreen(20))/2 - 1, fScreen(470));
    }
    else {
        layout.itemSize = CGSizeMake((width - fScreen(20))/2, fScreen(470));
    }
    
    CategoryDetailView *view = [[CategoryDetailView alloc] initWithFrame:CGRectZero collectionViewLayout:layout title:title modelArray:dataArray];
    
    __weak typeof(self) weakSelf = self;
    
    view.cellBlock = ^(GoodsModel *model) {
        GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:model.goodsId];
        [weakSelf.navigationController pushViewController:goodsVC animated:YES];
    };
    
    [view setBackgroundColor:viewControllerBgColor];
    return view;
}

- (void)initUI
{
    [self hideTabBar];
    [self hideNavigationBar];
    
    [self addTitleView];
}

- (void)addTitleView
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(40 + 88));
    }];
    self.titleView = titleView;
    
    UILabel *titleLabel = [self makeTitleLabelWithTitle:self.controllerTitle];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(titleView);
        make.height.mas_equalTo(fScreen(88));
    }];
    
    UIButton *backButton = [self makeBackButton];
    [titleView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.height.mas_offset(fScreen(88));
        make.width.mas_equalTo(fScreen(28*2 + 20));
        make.centerY.equalTo(titleView.mas_centerY).offset(fScreen(20));
    }];
    
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton setImage:[UIImage imageNamed:@"icon_search-wai"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backButton.mas_centerY);
        make.right.equalTo(titleView.mas_right);
        make.width.mas_equalTo(fScreen(36 + 30*2));
        make.height.mas_equalTo(fScreen(88));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:HexColor(0x999999)];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(titleView);
        make.height.mas_equalTo(@1);
    }];
}

- (void)searchButtonClick:(UIButton *)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithShopId:@""];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)toTopButtonClick:(UIButton *)sender
{
    CategoryDetailView *view = nil;
    UIViewController *currController = self.pageController.currController;
    for (UIView *subView in currController.view.subviews) {
        if ([subView isKindOfClass:[CategoryDetailView class]]) {
            view = (CategoryDetailView *)subView;
            break;
        }
    }
    [UIView animateWithDuration:0.5f animations:^{
        [view setContentOffset:CGPointMake(0, 0)];
    }];
}

@end

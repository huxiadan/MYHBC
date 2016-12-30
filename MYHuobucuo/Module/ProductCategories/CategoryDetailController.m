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
#import "CategoryDetailModel.h"
//#import "NetworkRequest.h"
#import "CategoryDetailPageController.h"

@interface CategoryDetailController ()

@property (nonatomic, copy) NSString *controllerTitle;
@property (nonatomic, strong) NSArray *categoryArray;
@property (nonatomic, assign) NSInteger initIndex;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) HDPageViewController *pageController;

@end

@implementation CategoryDetailController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithTitle:(NSString *)controllerTitle categoryArray:(NSArray<CategoryDetailModel *> *)categoryArray index:(NSInteger)index
{
    if (self = [super init]) {
        self.controllerTitle = controllerTitle;
        self.categoryArray = categoryArray;
        self.initIndex = index;
    }
    return self;
}

- (void)requestData
{
    NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:self.categoryArray.count];
    
    NSMutableArray *controllerArray = [NSMutableArray arrayWithCapacity:8];

    // 当前的索引
    NSString *currCategoryId = nil;
    
    for (CategoryDetailModel *model in self.categoryArray) {
        
        if (currCategoryId == nil) {
            currCategoryId = model.categoryId;
        }
        
        // 标题
        [titleArray addObjectSafe:model.categoryName];
        
        // 控制器
        CategoryDetailPageController *controller = [[CategoryDetailPageController alloc] initWithTitle:model.categoryName categoryId:model.categoryId];
        controller.currNavigationController = self.navigationController;
        
        [controllerArray addObject:controller];
    }
    
    self.pageController = [[HDPageViewController alloc] initWithFrame:CGRectZero titles:titleArray titleMargin:fScreen(78) titleHeight:0 firstTitleMargin:fScreen(48) titleFontSize:fScreen(28) controllers:[controllerArray copy]];
    
    self.pageController.TitleLineColor = HexColor(0xe44a62);
    self.pageController.currTitleColor = HexColor(0xe44a62);
    self.pageController.normalTitleColor = HexColor(0x999999);
    [self.pageController.view setBackgroundColor:viewControllerBgColor];
    [self.pageController moveToIndex:self.initIndex];
    
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

//
//  StoreCategoryViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreCategoryViewController.h"
#import <Masonry.h>
#import "CategoryDockCell.h"
#import "CategoryHeaderView.h"
#import "CategoryCollCell.h"
#import "StoreCategoryJumpController.h"

@interface StoreCategoryViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, strong) UITableView *dockView;                // 左边的 dock
@property (nonatomic, strong) UICollectionView *collectionView;     // 右边的子分类

@property (nonatomic, strong) NSArray *dockArray;                   // dock 的数据源
@property (nonatomic, strong) NSArray *dataArray;                   // 子分类的数据源
@property (nonatomic, assign) NSInteger currDockIndex;

@end

@implementation StoreCategoryViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.collectionView) {
        [self.collectionView setContentOffset:CGPointMake(0, 0)];
    }
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

- (instancetype)initWithShopId:(NSString *)shopId
{
    if (self = [super init]) {
        self.shopId = shopId;
    }
    return self;
}

- (void)setCanScroll
{
    [self.dockView setScrollEnabled:YES];
    [self.collectionView setScrollEnabled:YES];
}

- (void)setCanNotScroll
{
    [self.dockView setScrollEnabled:NO];
    [self.collectionView setScrollEnabled:NO];
}

- (void)requestData
{
    NSArray *dockArray = @[@"家电数码", @"新鲜蔬菜", @"休闲零食", @"服饰鞋帽",@"家电数码1", @"新鲜蔬菜1", @"休闲零食1", @"服饰鞋帽1",@"家电数码2", @"新鲜蔬菜2", @"休闲零食2", @"服饰鞋帽2",@"双十一狗粮"];
    NSMutableArray *tmpDoctArray = [NSMutableArray array];
    for (NSInteger index = 0; index < dockArray.count; index++) {
        CategoryDockModel *model = [[CategoryDockModel alloc] init];
        model.categoryName = dockArray[index];
        [tmpDoctArray addObject:model];
    }
    self.dockArray = tmpDoctArray;
    
    NSArray *cellNameArray = @[@"杨桃", @"苹果", @"葡萄",@"杨桃", @"苹果", @"葡萄",@"杨桃", @"苹果", @"葡萄"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 9; index++) {
        CategoryDetailModel *model = [[CategoryDetailModel alloc] init];
        model.categoryName = cellNameArray[index];
        [array addObject:model];
    }
    self.dataArray = @[@{@"水果": array}, @{@"狗粮" : array}, @{@"PHP" : array}];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self addDockView];
    NSIndexPath *firstIndex=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.dockView selectRowAtIndexPath:firstIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self addCollectionView];
    
    [self setCanNotScroll];
    
    self.height = kAppHeight - fScreen(88) - 20 - fScreen(88);
}

- (void)addDockView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.dockView = tableView;
    
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        make.width.mas_equalTo(fScreen(178));
        make.bottom.equalTo(self.view).offset(-fScreen(40));
    }];
}

- (void)addCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = kAppWidth - fScreen(178 + 30 + 30);
    CGFloat height = fScreen(30 + 28 + 30);
    layout.headerReferenceSize = CGSizeMake(width, height);
    layout.minimumLineSpacing = fScreen(20);
    layout.minimumInteritemSpacing = fScreen(20);
    
    if ([HDDeviceInfo isIPhone5Size] || [HDDeviceInfo isIPhone4Size]) {
        layout.itemSize = CGSizeMake((width - fScreen(20*2))/3 - 1, fScreen(210));
    }
    else {
        layout.itemSize = CGSizeMake((width - fScreen(20*2))/3, fScreen(210));
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:viewControllerBgColor];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    // 注册 header
    [self.collectionView registerClass:[CategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
    [self.collectionView registerClass:[CategoryCollCell class] forCellWithReuseIdentifier:collCellIdentity];
    
    [self.collectionView setDataSource:self];
    [self.collectionView setDelegate:self];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dockView.mas_right).offset(fScreen(30));
        make.right.equalTo(self.view.mas_right).offset(-fScreen(30));
        make.top.bottom.equalTo(self.dockView);
    }];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.scrollEnabled) {
        if (scrollView.contentOffset.y == 0) {
            if (self.scrollBlock) {
                self.scrollBlock();
            }
        }
    }
}

#pragma mark
#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dockArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitiiy];
    if (!cell) {
        cell = [[CategoryDockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentitiiy];
    }
    
    CategoryDockModel *model = [self.dockArray objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 改变 collectionView 数据源
}

#pragma mark
#pragma mark - collectionView dataSource & delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellIdentity forIndexPath:indexPath];
    
    NSDictionary *dict = [self.dataArray objectAtIndex:self.currDockIndex];
    
    NSArray *modelArray = [[dict allValues] objectAtIndex:0];
    
    cell.model = (CategoryDetailModel *)[modelArray objectAtIndex:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.jumpBlock) {
//        NSDictionary *dict = [self.dataArray objectAtIndex:self.currDockIndex];
//        
//        NSArray *modelArray = [[dict allValues] objectAtIndex:0];
//        
//        CategoryDetailModel *model = (CategoryDetailModel *)[modelArray objectAtIndex:indexPath.item];
//
//        self.jumpBlock(model.categoryName);
//    }
    
    NSDictionary *dict = [self.dataArray objectAtIndex:self.currDockIndex];
    
    NSArray *modelArray = [[dict allValues] objectAtIndex:0];
    
    CategoryDetailModel *model = (CategoryDetailModel *)[modelArray objectAtIndex:indexPath.item];
    
    StoreCategoryJumpController *jumpVC = [[StoreCategoryJumpController alloc] initWithShopId:self.shopId categoryTitle:model.categoryName mainView:self.view.superview];
    jumpVC.currNavigationController = self.currNavigationController;
    
    [self.currNavigationController pushViewController:jumpVC animated:YES];
}


// collectionView header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        CategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity forIndexPath:indexPath];
        
        NSString *titleText = [NSString stringWithFormat:@"%@",[((NSDictionary *)[self.dataArray objectAtIndex:indexPath.section]) allKeys][0]];
        headerView.titleText = titleText;
        
        reusableview = headerView;
    }
    
    return reusableview;
}

@end

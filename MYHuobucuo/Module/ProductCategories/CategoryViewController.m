//
//  CategoryViewController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "CategoryViewController.h"

#import <Masonry.h>
#import "CategoryDockCell.h"
#import "CategoryHeaderView.h"
#import "CategoryCollCell.h"
#import "CategoryDetailController.h"
#import "SearchViewController.h"

@interface CategoryViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UITableView *dockView;        // 左侧选项
@property (nonatomic, strong) NSArray *dockDataArray;       // 左侧选项数据源

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *colletionViewDataArray;

@property (nonatomic, assign) NSInteger currDockIndex;

@end

@implementation CategoryViewController

#pragma mark
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
 
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showTabBar];
    [self hideNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    // 模拟数据
    NSArray *dockArray = @[@"家电数码", @"新鲜蔬菜", @"休闲零食", @"服饰鞋帽",@"家电数码1", @"新鲜蔬菜1", @"休闲零食1", @"服饰鞋帽1",@"家电数码2", @"新鲜蔬菜2", @"休闲零食2", @"服饰鞋帽2",@"双十一狗粮"];
    NSMutableArray *tmpDoctArray = [NSMutableArray array];
    for (NSInteger index = 0; index < dockArray.count; index++) {
        CategoryDockModel *model = [[CategoryDockModel alloc] init];
        model.categoryName = dockArray[index];
        [tmpDoctArray addObject:model];
    }
    self.dockDataArray = tmpDoctArray;
    
    NSArray *cellNameArray = @[@"杨桃", @"苹果", @"葡萄",@"杨桃", @"苹果", @"葡萄",@"杨桃", @"苹果", @"葡萄"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger index = 0; index < 9; index++) {
        CategoryDetailModel *model = [[CategoryDetailModel alloc] init];
        model.categoryName = cellNameArray[index];
        [array addObject:model];
    }
    self.colletionViewDataArray = @[@{@"水果": array}, @{@"狗粮" : array}, @{@"PHP" : array}];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(40 + 88));
    }];
    
    [self.view addSubview:self.dockView];
    [self.dockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.topView.mas_bottom).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(178));
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);      // tabBar 的高度
    }];
    // 默认选中第一项
    NSIndexPath *firstIndex=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.dockView selectRowAtIndexPath:firstIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dockView.mas_right).offset(fScreen(30));
        make.right.equalTo(self.view.mas_right).offset(-fScreen(30));
        make.top.bottom.equalTo(self.dockView);
    }];
}

- (void)searchButtonClick:(UIButton *)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithShopId:@""];
    [self.navigationController pushViewController:searchVC animated:YES];
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dockDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDockCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentitiiy];
    if (!cell) {
        cell = [[CategoryDockCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentitiiy];
    }
    
    CategoryDockModel *model = [self.dockDataArray objectAtIndex:indexPath.row];
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 改变 collectionView 数据源
}


#pragma mark - collectionView dataSource & delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.colletionViewDataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellIdentity forIndexPath:indexPath];
    
    NSDictionary *dict = [self.colletionViewDataArray objectAtIndex:self.currDockIndex];
    
    NSArray *modelArray = [[dict allValues] objectAtIndex:0];
    
    cell.model = (CategoryDetailModel *)[modelArray objectAtIndex:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailController *detailVC = [[CategoryDetailController alloc] initWithTitle:@"水果"];
    [self.navigationController pushViewController:detailVC animated:YES];
}


// collectionView header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        CategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity forIndexPath:indexPath];

        NSString *titleText = [NSString stringWithFormat:@"%@",[((NSDictionary *)[self.colletionViewDataArray objectAtIndex:indexPath.section]) allKeys][0]];
        headerView.titleText = titleText;
        
        reusableview = headerView;
    }
    
    return reusableview;
}



#pragma mark - Getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:viewControllerBgColor];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        // 注册 header
        [_collectionView registerClass:[CategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
        [_collectionView registerClass:[CategoryCollCell class] forCellWithReuseIdentifier:collCellIdentity];
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
    }
    return _collectionView;
}

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        [_topView setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *iconView = [[UIImageView alloc] init];
        [iconView setImage:[UIImage imageNamed:@"icon_zhuye_logo-"]];
        [_topView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_topView.mas_left).offset(fScreen(28));
            make.width.mas_equalTo(fScreen(68));
            make.height.mas_equalTo(fScreen(68));
            make.centerY.equalTo(_topView.mas_centerY).offset(fScreen(20));
        }];
        
        UIView *searchView = [[UIView alloc] init];
        [searchView.layer setCornerRadius:fScreen(8)];
        [searchView.layer setBorderWidth:1.f];
        [searchView.layer setBorderColor:HexColor(0xdadada).CGColor];
        [_topView addSubview:searchView];
        [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconView.mas_right).offset(fScreen(30));
            make.right.equalTo(_topView.mas_right).offset(-fScreen(30));
            make.height.mas_equalTo(fScreen(58));
            make.centerY.equalTo(iconView.mas_centerY);
        }];
        
        UIImageView *searchIcon = [[UIImageView alloc] init];
        [searchIcon setImage:[UIImage imageNamed:@"icon_search-nei"]];
        [searchView addSubview:searchIcon];
    
        UILabel *searchLabel = [[UILabel alloc] init];
        [searchLabel setText:@"搜索更多优质好物"];
        [searchLabel setTextColor:HexColor(0xcecece)];
        [searchLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [searchView addSubview:searchLabel];
        
        CGSize textSize = [searchLabel.text sizeForFontsize:fScreen(24)];
        CGFloat searchWidth = kAppWidth - fScreen(28 + 68 + 30 + 30);
        CGFloat iconTextWidth = fScreen(28 + 20) + textSize.width + 2;
        
        [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchView.mas_left).offset((searchWidth - iconTextWidth)/2);
            make.centerY.equalTo(searchView.mas_centerY);
            make.width.mas_equalTo(fScreen(28));
            make.height.mas_equalTo(fScreen(28));
        }];
        [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(searchIcon.mas_right).offset(fScreen(20));
            make.centerY.equalTo(searchIcon.mas_centerY);
            make.width.mas_equalTo(textSize.width + 2);
            make.height.mas_equalTo(textSize.height);
        }];
        
        UIButton *searchButton = [[UIButton alloc] init];
        [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [searchView addSubview:searchButton];
        [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(searchView);
        }];
    }
    return _topView;
}

- (UITableView *)dockView
{
    if (!_dockView) {
        _dockView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_dockView setBackgroundColor:viewControllerBgColor];
        [_dockView setDataSource:self];
        [_dockView setDelegate:self];
        _dockView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dockView.showsVerticalScrollIndicator = NO;
    }
    return _dockView;
}


@end

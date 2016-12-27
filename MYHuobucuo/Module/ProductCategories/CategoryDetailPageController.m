//
//  CategoryDetailPageController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryDetailPageController.h"
#import "CategoryDetailView.h"
#import "GoodsViewController.h"
#import "HDRefresh.h"
#import <Masonry.h>
#import "NetworkRequest.h"
//#import "CategoryHeaderView.h"
#import "CategoryDetailCollCell.h"

static NSString *collHeaderViewIdentity = @"CategoryPageHeaderViewIdentity";

@interface CategoryDetailPageController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *detailView;

@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) NSUInteger currPage;

@end

@implementation CategoryDetailPageController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithTitle:(NSString *)title categoryId:(NSString *)categoryId
{
    if (self = [super init]) {
        
        self.titleText = title;
        
        self.categoryId = categoryId;
    }
    return self;
}

- (void)refreshData
{
    self.dataArray = nil;
    
    self.currPage = 1;
    
    // 刷新重置 footer 状态
    self.detailView.mj_footer.state = MJRefreshStateIdle;
    
    [self loadDataWithPageNumber:self.currPage];
}

- (void)loadMoreData
{
    self.currPage++;
    
    [self loadDataWithPageNumber:self.currPage];
}

- (void)loadDataWithPageNumber:(NSUInteger)pageNumber
{
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager getCategoryDetailListWithCategoryId:self.categoryId page:pageNumber finishBlock:^(id jsonData, NSError *error) {
        
        [weakSelf.detailView.mj_header endRefreshing];
        [weakSelf.detailView.mj_footer endRefreshing];
        
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
                NSArray *dataArray = jsonDict[@"data"];
                
                if (dataArray.count < 20) {
                    self.detailView.mj_footer.state = MJRefreshStateNoMoreData;
                }
                
                NSMutableArray *tmpArray;
                
                if (self.dataArray) {
                    tmpArray = [NSMutableArray arrayWithArray:self.dataArray];
                }
                else {
                    tmpArray = [NSMutableArray arrayWithCapacity:dataArray.count];
                }
                
                for (NSDictionary *dict in dataArray) {
                    GoodsModel *model = [[GoodsModel alloc] init];
                    [model setValueWithDict:dict];
                    [tmpArray addObject:model];
                }
                
                weakSelf.dataArray = [tmpArray copy];
                
                [weakSelf.detailView reloadData];
            }
        }
        
    }];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    if (![self.detailView superview]) {
        [self.view addSubview:self.detailView];
        
        [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
            make.left.equalTo(self.view.mas_left).offset(fScreen(30));
            make.right.equalTo(self.view.mas_right).offset(-fScreen(30));
        }];
    }
}

#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collidentity forIndexPath:indexPath];
    
    GoodsModel *model = [self.dataArray objectAtIndex:indexPath.item];
    cell.goodsModel = model;
    
    cell.addShoppingCarBlock = ^(GoodsModel *goodsModel) {
        DLog(@"加入购物车");
    };
    
    return cell;
}


#pragma mark - delegate
// 后台暂无数据,隐藏头部

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        CategoryPageHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity forIndexPath:indexPath];
        
//        headerView.titleText = self.titleText;
        
        reusableview = (UICollectionReusableView *)headerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsModel *model = (GoodsModel *)[self.dataArray objectAtIndex:indexPath.item];
    
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:model.goodsId];
    
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (UICollectionView *)detailView
{
    if (!_detailView) {
        
        // layout
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.minimumLineSpacing = fScreen(20);
        
        layout.minimumInteritemSpacing = fScreen(20);
        
        CGFloat width = kAppWidth - 2*fScreen(30);
        
//        layout.headerReferenceSize = CGSizeMake(width, fScreen(96));
        layout.headerReferenceSize = CGSizeMake(width, fScreen(20));
        
        if ([HDDeviceInfo isIPhone5Size] || [HDDeviceInfo isIPhone4Size]) {
            
            layout.itemSize = CGSizeMake((width - fScreen(20))/2 - 1, fScreen(470));
        }
        else {
            
            layout.itemSize = CGSizeMake((width - fScreen(20))/2, fScreen(470));
        }
        
        // collectionView
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];

        collectionView.dataSource = self;
        collectionView.delegate = self;
        
        // 注册
        [collectionView registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [collectionView registerClass:[CategoryPageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
        
        collectionView.showsVerticalScrollIndicator = NO;
        
        __weak typeof(self) weakSelf = self;
        
        [collectionView setBackgroundColor:viewControllerBgColor];
        
        //  刷新 header & footer
        collectionView.mj_header = [RefreshHeader headerWithTitle:@"下拉刷新数据" freshingTitle:@"正在刷新数据" freshBlock:^{
            [weakSelf refreshData];
        }];
        
        collectionView.mj_footer = [RefreshFooter footerWithTitle:@"上拉加载更多数据" uploadingTitle:@"正在加载数据..." noMoreTitle:@"木有啦~" uploadBlock:^{
            [weakSelf loadMoreData];
        }];
        
        _detailView = collectionView;
        
    }
    return _detailView;
}


@end


#pragma mark
#pragma mark - CategoryPageHeaderView

@implementation CategoryPageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:viewControllerBgColor];
    }
    return self;
}

@end

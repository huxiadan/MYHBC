//
//  CollectionShopController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CollectionShopController.h"
#import <Masonry.h>
#import "ShareView.h"
#import "CollShopCell.h"

@interface CollectionShopController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *shopListView;

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation CollectionShopController

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

- (void)requestData
{
    // 模拟数据
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger index = 0; index< 10; index++) {
        CollShopModel *model = [[CollShopModel alloc] init];
        model.shopName = @"厦门老干妈专卖店";
        if (index%3 == 0) {
            model.iconType = ShopIconType_Brand;
        }
        else if (index == 5) {
            model.iconType = ShopIconType_Personal;
        }
        else {
            model.iconType = ShopIconType_None;
        }
        
        [tmpArray addObject:model];
    }
    self.dataList = [tmpArray copy];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"我收藏的店铺"];
    
    [self.view addSubview:self.shopListView];
    [self.shopListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
    }];
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[CollShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    CollShopModel *model = (CollShopModel *)[self.dataList objectAtIndex:indexPath.row];
    cell.model = model;
    __weak typeof(self) weakSelf = self;
    cell.shareBlock = ^(ShareModel *shareModel) {
        ShareView *shareView = [[ShareView alloc] init];
        [weakSelf.view addSubview:shareView];
        shareView.shareModel = shareModel;
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCollShopCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


- (UITableView *)shopListView
{
    if (!_shopListView) {
        _shopListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_shopListView setDataSource:self];
        [_shopListView setDelegate:self];
        _shopListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _shopListView.showsVerticalScrollIndicator = NO;
        [_shopListView setBackgroundColor:viewControllerBgColor];
    }
    return _shopListView;
}

@end
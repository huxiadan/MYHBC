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
#import "NetworkRequest.h"

#define kPageSize 15

@interface CollectionShopController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *shopListView;
@property (nonatomic, strong) UIView *emptyView;

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
//    NSMutableArray *tmpArray = [NSMutableArray array];
//    for (NSInteger index = 0; index< 10; index++) {
//        CollShopModel *model = [[CollShopModel alloc] init];
//        model.shopName = @"厦门老干妈专卖店";
//        if (index%3 == 0) {
//            model.iconType = ShopIconType_Brand;
//        }
//        else if (index == 5) {
//            model.iconType = ShopIconType_Personal;
//        }
//        else {
//            model.iconType = ShopIconType_None;
//        }
//        
//        [tmpArray addObject:model];
//    }
//    self.dataList = [tmpArray copy];
    
    [MYProgressHUD showWaitingViewWithMessage:@"加载中..."];
    
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager getUserCollectStoreListWithPage:1 pageSize:kPageSize finishBlock:^(id jsonData, NSError *error) {
        
        [MYProgressHUD dismissMessageView];
        
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
                NSArray *dataArray = [dataDict objectForKey:@"lists"];
                if (dataArray.count > 0) {
                    
                    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:dataArray.count];
                    
                    for (NSDictionary *dict in dataArray) {
                        CollShopModel *shopModel = [[CollShopModel alloc] init];
                        [shopModel setValueWithDict:dict];
                        
                        [tmpArray addObject:shopModel];
                    }
                    
                    weakSelf.dataList = [tmpArray copy];
                    
                    [weakSelf.shopListView reloadData];
                    
                    [weakSelf.emptyView setHidden:YES];
                }
                else {
                    
                    [weakSelf.emptyView setHidden:NO];
                }
            }
        }
    }];
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
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    [self.emptyView setHidden:YES];
}

#pragma mark - Getter
- (UIView *)emptyView
{
    if (!_emptyView) {
        UIView *emptyView = [[UIView alloc] init];
        [emptyView setBackgroundColor:self.view.backgroundColor];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"img_dianpu_kong@3x" ofType:nil];
        UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        [emptyView addSubview:emptyImageView];
        [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fScreen(240));
            make.width.mas_equalTo(fScreen(298));
            make.top.equalTo(emptyView).offset(fScreen(220));
            make.centerX.equalTo(emptyView.mas_centerX);
        }];
        
        _emptyView = emptyView;
    }
    return _emptyView;
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
        shareView.currNaviController = weakSelf.navigationController;
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

//
//  AddressController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressController.h"
#import "AddressTabCell.h"
#import "AddressTabFooterView.h"
#import "AddressEditController.h"
#import "MYSingleTon.h"
#import <Masonry.h>

@interface AddressController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UITableView *addressListView;

@end

@implementation AddressController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_addressListView) {
        [self.addressListView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)dealloc
{
    [MYSingleTon sharedMYSingleTon].addressModelArray = nil;
}

- (void)requestData
{
    // 模拟数据
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSInteger index = 0; index < 5; index++) {
        AddressModel *model = [[AddressModel alloc] init];
        
        model.receivePersonName = [NSString stringWithFormat:@"厦门吴彦祖-%ld",index];
        model.phoneNumber = @"18695696529";
        model.province = @"福建省";
        model.city = @"厦门市";
        model.area = @"思明区";
        model.address = @"莲前街道软件园二期望海路63号";
        model.isDefaultAddress = index == 0 ? YES : NO;
        
        [tmpArray addObject:model];
    }
    [MYSingleTon sharedMYSingleTon].addressModelArray = [tmpArray copy];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"管理收货地址"];
    
    [self.view addSubview:self.addressListView];
    [self.addressListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MYSingleTon sharedMYSingleTon].addressModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[AddressTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    cell.addrModel = (AddressModel *)[[MYSingleTon sharedMYSingleTon].addressModelArray objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    cell.deleteBlock = ^(AddressModel *model) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[MYSingleTon sharedMYSingleTon].addressModelArray];
        [tmpArray removeObject:model];
        [MYSingleTon sharedMYSingleTon].addressModelArray = [tmpArray copy];
    
        [weakSelf.addressListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [weakSelf.addressListView reloadData];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 跳转地址编辑页面
    AddressModel *model = (AddressModel *)[[MYSingleTon sharedMYSingleTon].addressModelArray objectAtIndex:indexPath.row];
    AddressEditController *editController = [[AddressEditController alloc] initWithModel:model];
    [self.navigationController pushViewController:editController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    AddressTabFooterView *footer = [[AddressTabFooterView alloc] init];
    footer.clickBlock = ^() {
        // 跳转添加地址页面
        AddressEditController *editController = [[AddressEditController alloc] initWithModel:nil];
        [self.navigationController pushViewController:editController animated:YES];
    };
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAddressTabCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return kAddressTabFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


#pragma mark - Getter
- (UITableView *)addressListView
{
    if (!_addressListView) {
        _addressListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_addressListView setBackgroundColor:viewControllerBgColor];
        [_addressListView setDelegate:self];
        [_addressListView setDataSource:self];
        [_addressListView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _addressListView;
}

@end

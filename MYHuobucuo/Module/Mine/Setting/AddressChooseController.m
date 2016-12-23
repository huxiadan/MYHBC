//
//  AddressChooseController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/19.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressChooseController.h"
#import "AddressChooseTabCell.h"
#import "AddressTabFooterView.h"
#import "AddressEditController.h"
#import "MYSingleTon.h"
#import <Masonry.h>

@interface AddressChooseController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UITableView *addressListView;

@end

@implementation AddressChooseController

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
        
        if (index == 1) {
            model.province = @"北京市";
        }
        
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
    
    // 确定按钮
    UIButton *sureButton = [[UIButton alloc] init];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleView).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(30*2 + viewControllerTitleFontSize*2));
        make.top.equalTo(self.titleView.mas_top).offset(20);
    }];
    
    [self.view addSubview:self.addressListView];
    [self.addressListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
}

#pragma mark - button click
- (void)sureButtonClick:(UIButton *)sender
{
    [MYSingleTon sharedMYSingleTon].isNeedUpdateAddress = YES;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [MYSingleTon sharedMYSingleTon].addressModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressChooseTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[AddressChooseTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
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
    
    cell.defaultBlock = ^() {
        [weakSelf.addressListView reloadData];
    };
    
    cell.selectBlock = ^(AddressModel *model) {
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

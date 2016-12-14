//
//  CollectionGoodsController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CollectionGoodsController.h"
#import "CollGoodsCell.h"
#import "ShareView.h"
#import <Masonry.h>

@interface CollectionGoodsController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *topItemView;
@property (nonatomic, strong) UIView *itemViewLineLeft;     // 收藏的商品下划线
@property (nonatomic, strong) UIView *itemViewLineRight;    // 失效的商品下划线
@property (nonatomic, strong) UIButton *collButton;         // 收藏的商品按钮
@property (nonatomic, strong) UIButton *invalidButton;      // 失效的商品按钮

@property (nonatomic, strong) UIView *editView;             // 编辑状态显示的底部视图

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) UITableView *invListView;     // 失效商品的展示列表
@property (nonatomic, strong) NSArray *invDataList;         // 失效商品 tab 的数据源
@property (nonatomic, strong) UIButton *batchDeleteButton;  // 失效商品中的批量删除按钮

@property (nonatomic, assign) BOOL isShowInvalid;           // 当前是否在显示无效商品

@end

@implementation CollectionGoodsController

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
    // 全部
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 6; index++) {
        CollGoodsModel *model = [[CollGoodsModel alloc] init];
        model.goodsName = [NSString stringWithFormat:@"老子随手就是一个标准的十五个字-%ld 老子随手就是一个标准的十五个字老子随手就是一个标准的十五个字", index];
        model.goodsPrice = @"88.8";
        model.isInvalid = index == 3 ? YES : NO;
        [tmpArray addObject:model];
    }
    self.dataList = [tmpArray copy];
    
    // 失效
    NSMutableArray *invTmpArray = [[NSMutableArray alloc] init];
    for (NSInteger index = 0; index < 6; index++) {
        CollGoodsModel *model = [[CollGoodsModel alloc] init];
        model.goodsName = [NSString stringWithFormat:@"我已经是一个废商品了- %ld", index];
        model.goodsPrice = @"88.8";
        model.isInvalid = YES;
        [invTmpArray addObject:model];
    }
    self.invDataList = [invTmpArray copy];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"我收藏的商品"];
    
    [self addTopItemView];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topItemView.mas_bottom).offset(fScreen(20));
    }];
    
    // 无效的商品(默认隐藏)
    [self.view addSubview:self.invListView];
    [self.invListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.topItemView.mas_bottom).offset(fScreen(20));
    }];
    
    [self.view addSubview:self.editView];
    [self.editView setHidden:YES];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(fScreen(98));
    }];
    
    [self.view addSubview:self.batchDeleteButton];
    [self.batchDeleteButton setHidden:YES];
    [self.batchDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(fScreen(98));
    }];
}

- (void)addTopItemView
{
    UIView *itemView = [[UIView alloc] init];
    [itemView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(fScreen(70));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [itemView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(itemView);
        make.height.equalTo(@1);
    }];
    self.topItemView = itemView;
    
    // 完成
    UIButton *editButton = [[UIButton alloc] init];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [editButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(itemView);
        make.width.mas_equalTo(fScreen(116));
    }];
    
    UIView *lineView2 = [[UIView alloc] init];
    [lineView2 setBackgroundColor:viewControllerBgColor];
    [itemView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(itemView.mas_centerY);
        make.width.equalTo(@1);
        make.right.equalTo(editButton.mas_left);
        make.height.mas_equalTo(fScreen(28));
    }];
    
    
    CGSize textSize = [@"收藏的商品" sizeForFontsize:fScreen(28)];
    
    // 收藏的商品
    UIButton *collButton = [[UIButton alloc] init];
    [collButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [collButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [collButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateSelected];
    [collButton setTitle:@"收藏的商品" forState:UIControlStateNormal];
    [collButton addTarget:self action:@selector(collButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:collButton];
    [collButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(itemView.mas_left).offset(fScreen(74));
        make.centerY.equalTo(itemView.mas_centerY);
        make.width.mas_equalTo(textSize.width + 2);
        make.height.mas_equalTo(textSize.height);
    }];
    [collButton setSelected:YES];
    self.collButton = collButton;
    
    // 失效的商品
    UIButton *invalidButton = [[UIButton alloc] init];
    [invalidButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [invalidButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [invalidButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateSelected];
    [invalidButton setTitle:@"失效的商品" forState:UIControlStateNormal];
    [invalidButton addTarget:self action:@selector(invalidButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:invalidButton];
    [invalidButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(editButton.mas_left).offset(-fScreen(74));
        make.centerY.equalTo(itemView.mas_centerY);
        make.width.mas_equalTo(textSize.width + 2);
        make.height.mas_equalTo(textSize.height);
    }];
    self.invalidButton = invalidButton;
    
    // 底部横线
    UIView *itemLineLeft = [[UIView alloc] init];
    [itemLineLeft setBackgroundColor:HexColor(0xe44a62)];
    [itemView addSubview:itemLineLeft];
    [itemLineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(collButton.mas_centerX);
        make.bottom.equalTo(itemView.mas_bottom);
        make.height.equalTo(@1);
        make.width.mas_equalTo(textSize.width + fScreen(16*2));
    }];
    self.itemViewLineLeft = itemLineLeft;
    
    UIView *itemLineRight = [[UIView alloc] init];
    [itemLineRight setBackgroundColor:HexColor(0xe44a62)];
    [itemView addSubview:itemLineRight];
    [itemLineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(invalidButton.mas_centerX);
        make.bottom.equalTo(itemView.mas_bottom);
        make.height.equalTo(@1);
        make.width.mas_equalTo(textSize.width + fScreen(16*2));
    }];
    self.itemViewLineRight = itemLineRight;
    [self.itemViewLineRight setHidden:YES];
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.isShowInvalid ? self.invDataList.count : self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CollGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[CollGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    CollGoodsModel *model;
    
    if (self.isShowInvalid) {
        model = (CollGoodsModel *)[self.invDataList objectAtIndex:indexPath.row];
    }
    else {
        model = (CollGoodsModel *)[self.dataList objectAtIndex:indexPath.row];
    }
    
    cell.model = model;
    cell.collectBlock = ^(BOOL isCollect) {};
    
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
    return kCollGoodsCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footer = [[UIView alloc] init];
    [footer setBackgroundColor:viewControllerBgColor];
    return footer;
}

#pragma mark - button Click
- (void)editButtonClick:(UIButton *)sender
{
    BOOL isEdit = NO;
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        isEdit = YES;
        // 进入编辑状态,商品和无效商品不和切换
        self.collButton.userInteractionEnabled = self.invalidButton.userInteractionEnabled = NO;
        
        if (self.collButton.isSelected) {
            [self.editView setHidden:NO];
        }
        else {
            [self.batchDeleteButton setHidden:NO];
        }
    }
    else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        isEdit = NO;
        self.collButton.userInteractionEnabled = self.invalidButton.userInteractionEnabled = YES;
        
        if (self.collButton.isSelected) {
            [self.editView setHidden:YES];
        }
        else {
            [self.batchDeleteButton setHidden:YES];
        }
    }
    
    if (self.collButton.isSelected) {
        for (CollGoodsModel *collModel in self.dataList) {
            collModel.isEdit = isEdit;
        }
        
        [self.listView reloadData];
    }
    else {
        for (CollGoodsModel *collModel in self.invDataList) {
            collModel.isEdit = isEdit;
        }
        
        [self.invListView reloadData];
    }
}

// 收藏的商品
- (void)collButtonClick:(UIButton *)sender
{
    self.isShowInvalid = NO;
    [self.itemViewLineLeft setHidden:NO];
    [self.itemViewLineRight setHidden:YES];
    
    self.invalidButton.selected = NO;
    self.collButton.selected = YES;
    
    [self.listView setHidden:NO];
    [self.invListView setHidden:YES];
    
    [self.listView reloadData];
}

// 失效的商品
- (void)invalidButtonClick:(UIButton *)sender
{
    self.isShowInvalid = YES;
    [self.itemViewLineRight setHidden:NO];
    [self.itemViewLineLeft setHidden:YES];
    
    self.invalidButton.selected = YES;
    self.collButton.selected = NO;
    
    [self.listView setHidden:YES];
    [self.invListView setHidden:NO];
    
    [self.invListView reloadData];
}

// 加入购物车
- (void)addShopCarButtonClick:(UIButton *)sender
{}

// 批量删除
- (void)batchDeleteButtonClick:(UIButton *)sender
{}

// 批量删除(无效商品界面)
- (void)invBatchDeleteButtonClick:(UIButton *)sender
{}

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_listView setDataSource:self];
        [_listView setDelegate:self];
        _listView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listView.showsVerticalScrollIndicator = NO;
        [_listView setBackgroundColor:viewControllerBgColor];
    }
    return _listView;
}

- (UITableView *)invListView
{
    if (!_invListView) {
        _invListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_invListView setDataSource:self];
        [_invListView setDelegate:self];
        _invListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _invListView.showsVerticalScrollIndicator = NO;
        [_invListView setBackgroundColor:viewControllerBgColor];
        
        [_invListView setHidden:YES];
    }
    return _invListView;
}

- (UIView *)editView
{
    if (!_editView) {
        _editView = [[UIView alloc] init];
        [_editView setBackgroundColor:[UIColor whiteColor]];
        
        // 加入购物车
        UIButton *addShopCarButton = [[UIButton alloc] init];
        [addShopCarButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [addShopCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addShopCarButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
        [addShopCarButton addTarget:self action:@selector(addShopCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:addShopCarButton];
        [addShopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(_editView);
            make.right.equalTo(_editView.mas_centerX);
        }];
        
        // 批量删除
        UIButton *batchDeleteButton = [[UIButton alloc] init];
        [batchDeleteButton setBackgroundColor:HexColor(0xe44a62)];
        [batchDeleteButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [batchDeleteButton setTitle:@"批量删除" forState:UIControlStateNormal];
        [batchDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [batchDeleteButton addTarget:self action:@selector(batchDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:batchDeleteButton];
        [batchDeleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(_editView);
            make.left.equalTo(_editView.mas_centerX);
        }];
    }
    return _editView;
}

- (UIButton *)batchDeleteButton
{
    if (!_batchDeleteButton) {
        _batchDeleteButton = [[UIButton alloc] init];
        [_batchDeleteButton setBackgroundColor:HexColor(0xe44a62)];
        [_batchDeleteButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [_batchDeleteButton setTitle:@"批量删除" forState:UIControlStateNormal];
        [_batchDeleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_batchDeleteButton addTarget:self action:@selector(invBatchDeleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _batchDeleteButton;
}

@end

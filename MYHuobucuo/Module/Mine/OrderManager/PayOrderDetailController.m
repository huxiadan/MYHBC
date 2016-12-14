//
//  PayOrderDetailController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/6.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "PayOrderDetailController.h"
#import <Masonry.h>
#import "HDLabel.h"
#import "NSAttributedString+HD.h"
#import "MineOrderTabCell.h"
#import "MineOrderTabHeaderView.h"
#import "OrderDetailModel.h"
#import "PayViewController.h"
#import "GoodsViewController.h"

@interface PayOrderDetailController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UITableView *orderListView;                   // 订单列表
@property (nonatomic, strong) UIView *addressView;                          // 表头部的地址
@property (nonatomic, strong) UIView *orderFooterView;                      // 表底部的留言等
@property (nonatomic, strong) UIView *bottomPayView;                        // 底部支付
@property (nonatomic, strong) NSArray<OrderShopModel *> *shopModelArray;    // 数据源

@property (nonatomic, copy) NSString *nameString;       // 收货人
@property (nonatomic, copy) NSString *phoneString;      // 联系电话
@property (nonatomic, copy) NSString *addressString;    // 收货地址
@property (nonatomic, assign) CGFloat addrHeight;       // 地址的高度
@property (nonatomic, copy) NSString *commossion;       // 佣金
@property (nonatomic, copy) NSString *numberCount;      // 结算商品总数
@property (nonatomic, copy) NSString *payCount;         // 结算金额

@end

@implementation PayOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithPayArray:(NSArray<OrderShopModel *> *)payArray
{
    if (self = [super init]) {
        self.shopModelArray = payArray;
    }
    return self;
}

- (void)requestData
{
    self.addressString = @"胡建省厦门市思明区莲前街道软家园二期望海路63号之一没有之二";
    self.nameString = @"欧雷瓦王大锤";
    self.phoneString = @"18695696529";
    
    self.payCount = @"999.98";
    self.numberCount = @"3";
    self.commossion = @"122";
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"订单详情"];
    
    self.bottomPayView = [self makeBottomPayView];
    [self.view addSubview:self.bottomPayView];
    [self.bottomPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(84));
    }];
    
    self.orderFooterView = [self makeOrderFooterView];
    
    self.addressView = [self makeAddressView];
    
    [self.view addSubview:self.orderListView];
    [self.orderListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.equalTo(self.bottomPayView.mas_top);
    }];
}

- (UITableView *)orderListView
{
    if (!_orderListView) {
        UITableView *listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [listView setDataSource:self];
        [listView setDelegate:self];
        [listView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [listView setBackgroundColor:self.view.backgroundColor];
        [listView setShowsVerticalScrollIndicator:NO];
        
        // tableView 头
        listView.tableHeaderView = self.addressView;
        listView.tableHeaderView.frame = CGRectMake(0, 0, kAppWidth, self.addrHeight);

        // tableView 底
        CGFloat bottomHeight = (fScreen(84) + 1)*4;
        
        listView.tableFooterView = self.orderFooterView;
        [listView.tableFooterView setFrame:CGRectMake(0, 0, kAppWidth, bottomHeight)];;
        
        [listView setContentInset:UIEdgeInsetsMake(-30, 0, fScreen(40), 0)];
        
        _orderListView = listView;
    }
    
    return _orderListView;
}

- (UIView *)makeBottomPayView
{
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *buyButton = [[UIButton alloc] init];
    [buyButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [buyButton setTitle:@"立即付款" forState:UIControlStateNormal];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyButton setBackgroundColor:HexColor(0xe44a62)];
    [buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyButton];
    [buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(bottomView);
        make.width.mas_equalTo(fScreen(200));
    }];
    
    UILabel *countLabel = [[UILabel alloc] init];
    [countLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [countLabel setTextColor:HexColor(0x333333)];
    [countLabel setTextAlignment:NSTextAlignmentRight];
    NSString *payCountString = [NSString stringWithFormat:@"合计: ¥%@", self.payCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:payCountString];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : HexColor(0xe44a62)};
    [attrString addAttributes:attrDict range:NSMakeRange(4, attrString.length - 4)];
    [countLabel setAttributedText:attrString];
    [bottomView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(buyButton.mas_left).offset(-fScreen(30));
        make.top.bottom.left.equalTo(bottomView);
    }];
    
    
    return bottomView;
}

- (UIView *)makeOrderFooterView
{
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:self.view.backgroundColor];
    
    // 返佣
    UIView *backMoneyView = [[UIView alloc] init];
    [backMoneyView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:backMoneyView];
    [backMoneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(bottomView);
        make.height.mas_equalTo(fScreen(84));
    }];
    
    UILabel *backMoneyTitleLabel = [[UILabel alloc] init];
    [backMoneyTitleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [backMoneyTitleLabel setTextColor:HexColor(0x666666)];
    [backMoneyTitleLabel setText:@"下单后立即返佣"];
    [backMoneyView addSubview:backMoneyTitleLabel];
    [backMoneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backMoneyView).offset(fScreen(28));
        make.top.bottom.equalTo(backMoneyView);
        make.width.mas_equalTo(fScreen(300));
    }];
    
    UILabel *backMoneyInfoLabel = [[UILabel alloc] init];
    [backMoneyInfoLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [backMoneyInfoLabel setTextColor:HexColor(0x666666)];
    [backMoneyInfoLabel setTextAlignment:NSTextAlignmentRight];
    [backMoneyInfoLabel setText:[NSString stringWithFormat:@"¥%@", self.commossion]];
    [backMoneyView addSubview:backMoneyInfoLabel];
    [backMoneyInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backMoneyView).offset(-fScreen(28));
        make.top.bottom.equalTo(backMoneyView);
        make.width.mas_equalTo(fScreen(300));
    }];
    
    
    // 配送
    UIView *sendWayView = [[UIView alloc] init];
    [sendWayView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:sendWayView];
    [sendWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backMoneyView);
        make.top.equalTo(backMoneyView.mas_bottom).offset(1);
        make.height.mas_equalTo(fScreen(84));
    }];
    
    UILabel *sendWayTitleLabel = [[UILabel alloc] init];
    [sendWayTitleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [sendWayTitleLabel setTextColor:HexColor(0x666666)];
    [sendWayTitleLabel setText:@"配送方式"];
    [sendWayView addSubview:sendWayTitleLabel];
    [sendWayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(sendWayView).offset(fScreen(28));
        make.top.bottom.equalTo(sendWayView);
        make.width.mas_equalTo(fScreen(300));
    }];
    
    UILabel * sendWayInfoLabel = [[UILabel alloc] init];
    [sendWayInfoLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [sendWayInfoLabel setTextColor:HexColor(0x666666)];
    [sendWayInfoLabel setTextAlignment:NSTextAlignmentRight];
    [sendWayInfoLabel setText:@"快递 免邮"];
    [sendWayView addSubview:sendWayInfoLabel];
    [sendWayInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sendWayView).offset(-fScreen(28));
        make.top.bottom.equalTo(sendWayView);
        make.width.mas_equalTo(fScreen(300));
    }];
    
    // 留言
    UIView *noteView = [[UIView alloc] init];
    [noteView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:noteView];
    [noteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sendWayView);
        make.top.equalTo(sendWayView.mas_bottom).offset(1);
        make.height.mas_equalTo(fScreen(84));
    }];
    
    UILabel *noteTitleLabel = [[UILabel alloc] init];
    [noteTitleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [noteTitleLabel setTextColor:HexColor(0x666666)];
    [noteTitleLabel setText:@"买家留言:"];
    [noteView addSubview:noteTitleLabel];
    [noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteView).offset(fScreen(28));
        make.top.bottom.equalTo(noteView);
        make.width.mas_equalTo(fScreen(160));
    }];
    
    UITextField *noteField = [[UITextField alloc] init];
    [noteField setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [noteField setTextColor:HexColor(0x999999)];
    [noteField setPlaceholder:@"(可填写与卖家协商一致的要求)"];
    [noteField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [noteView addSubview:noteField];
    [noteField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteTitleLabel.mas_right).offset(fScreen(28));
        make.top.bottom.equalTo(noteView);
        make.right.equalTo(noteView).offset(-fScreen(28));
    }];
    
    // 合计
    UIView *countView = [[UIView alloc] init];
    [countView setBackgroundColor:[UIColor whiteColor]];
    [bottomView addSubview:countView];
    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(noteView);
        make.top.equalTo(noteView.mas_bottom).offset(1);
        make.height.mas_equalTo(fScreen(84));
    }];
    
    NSString *countString = [NSString stringWithFormat:@"共%@件商品 共计: %@", self.numberCount, self.payCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:countString];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : HexColor(0xe44a62)};
    [attrString addAttributes:attrDict range:NSMakeRange(countString.length - self.payCount.length, self.payCount.length)];
    UILabel *countLabel = [[UILabel alloc] init];
    [countLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [countLabel setTextColor:HexColor(0x333333)];
    [countLabel setTextAlignment:NSTextAlignmentRight];
    [countLabel setAttributedText:attrString];
    [countView addSubview:countLabel];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(countView);
        make.right.equalTo(countView).offset(-fScreen(28));
    }];
    
    return bottomView;
}

// 地址
- (UIView *)makeAddressView
{
    UIView *addrView = [[UIView alloc] init];
    [addrView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dizhi"]];
    [addrView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrView).offset(fScreen(30));
        make.centerY.equalTo(addrView);
        make.height.mas_equalTo(fScreen(44));
        make.width.mas_equalTo(fScreen(44));
    }];
    
    UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_fengexian"]];
    [addrView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(addrView);
        make.height.mas_equalTo(fScreen(6));
    }];
    
    UIImageView *moreView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_gengduo"]];
    [addrView addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addrView).offset(-fScreen(30));
        make.centerY.equalTo(addrView);
        make.height.mas_equalTo(fScreen(42));
        make.width.mas_equalTo(fScreen(42));
    }];
    
    // 收货人
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [nameLabel setText:[NSString stringWithFormat:@"收货人: %@", self.nameString]];
    [addrView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrView).offset(fScreen(100));
        make.top.equalTo(addrView).offset(fScreen(30));
        make.height.mas_equalTo(fScreen(28));
        make.width.mas_equalTo(fScreen(340));
    }];
    
    // 电话
    UILabel *phoneLabel = [[UILabel alloc] init];
    [phoneLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [phoneLabel setTextColor:HexColor(0x333333)];
    [phoneLabel setTextAlignment:NSTextAlignmentRight];
    [phoneLabel setText:[NSString stringWithFormat:@"%@", self.phoneString]];
    [addrView addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addrView).offset(-fScreen(100));
        make.top.height.equalTo(nameLabel);
        make.left.equalTo(nameLabel.mas_right).offset(fScreen(20));
    }];
    
    self.addrHeight += fScreen(30 + 28);
    
    // 地址
    HDLabel *addrLabel = [[HDLabel alloc] init];
    [addrLabel setFont:[UIFont systemFontOfSize:24]];
    [addrLabel setNumberOfLines:0];
    [addrLabel setTextColor:HexColor(0x333333)];
    
    NSAttributedString *addrString = [NSAttributedString getAttributeString:self.addressString lineSpacing:fScreen(13)];
    NSMutableAttributedString *addrString2 = [[NSMutableAttributedString alloc] initWithAttributedString:addrString];
    NSDictionary *fontAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]};
    [addrString2 addAttributes:fontAttr range:NSMakeRange(0, addrString.length)];
    
    [addrLabel setAttributedText:addrString2];
    
    addrLabel.width = kAppWidth - fScreen(100) * 2;
    CGFloat addrLabelHeight = addrLabel.textHeight;
    BOOL isOneLine = (addrLabelHeight - fScreen(13)) == [@"高度" sizeForFontsize:fScreen(24)].height;
    
    CGFloat addrHeight = 0;
    
    if (isOneLine) {
        [addrLabel setText:self.addressString];
        addrHeight = [@"高度" sizeForFontsize:fScreen(24)].height;
    }
    else {
        addrHeight = addrLabelHeight + fScreen(16/2);
    }
    
    [addrView addSubview:addrLabel];
    [addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrView).offset(fScreen(100));
        make.right.equalTo(addrView).offset(-fScreen(100));
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(18));
        make.height.mas_equalTo(addrHeight);
    }];
    
    self.addrHeight += fScreen(18) + addrHeight;
    
    // 说明
    UILabel *infoLabel = [[UILabel alloc] init];
    [infoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [infoLabel setTextColor:HexColor(0xe79433)];
    [infoLabel setText:@"(收货不方便时, 可选择免费代收服务)"];
    [addrView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(addrLabel);
        make.height.mas_equalTo(fScreen(24));
        make.top.equalTo(addrLabel.mas_bottom).offset(fScreen(20));
    }];
    
    UIButton *changeAddrButton = [[UIButton alloc] init];
    [changeAddrButton addTarget:self action:@selector(changeAddrButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addrView addSubview:changeAddrButton];
    [changeAddrButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(addrView);
        make.width.mas_equalTo(fScreen(200));
    }];
    
    self.addrHeight += fScreen(20 + 24 + 30 + 6);
    
    return addrView;
}

#pragma mark
#pragma mark - tableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.shopModelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderShopModel *shopModel = (OrderShopModel *)[self.shopModelArray objectAtIndex:section];
    
    return [shopModel.goodsArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[MineOrderTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    NSArray *modelArray = ((OrderShopModel *)[self.shopModelArray objectAtIndex:indexPath.section]).goodsArray;
    OrderModel *model = (OrderModel *)[modelArray objectAtIndex:indexPath.row];
    
    cell.orderModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderShopModel *shopModel = (OrderShopModel *)[self.shopModelArray objectAtIndex:indexPath.section];
    OrderModel *orderModel = (OrderModel *)[shopModel.goodsArray objectAtIndex:indexPath.row];
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:orderModel.goodsId];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MineOrderTabHeaderView *header = [[MineOrderTabHeaderView alloc] init];
    header.orderShopModel = (OrderShopModel *)[self.shopModelArray objectAtIndex:section];
    
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMineOrderTabCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kMineOrderTabHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - button click
- (void)changeAddrButtonClick:(UIButton *)sender
{
    
}

- (void)buyButtonClick:(UIButton *)sender
{
    PayViewController *payVC = [[PayViewController alloc] initWithOrderNo:@"8787737989384839" payMoney:@"322.90"];
    [self.navigationController pushViewController:payVC animated:YES];
}

@end

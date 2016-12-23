//
//  MineOrderDetailController.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/25.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineOrderDetailController.h"
#import <Masonry.h>
#import "OrderDetailModel.h"
#import "NSAttributedString+HD.h"
#import "HDLabel.h"
#import "MineOrderTabCell.h"
#import "MineOrderTabHeaderView.h"
#import "OrderModel.h"
#import "MineOrderDetailTabFooterView.h"
#import "MineGroupOrderDetailTabFooterView.h"
#import "ShareView.h"
#import "GroupbuyOrderController.h"
#import "GoodsViewController.h"

@interface MineOrderDetailController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *shopId;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *orderInfoView;
@property (nonatomic, strong) UIView *orderDetailInfoView;
@property (nonatomic, strong) UITableView *orderListView;

@property (nonatomic, strong) OrderDetailModel *orderDetailModel;
@property (nonatomic, assign) CGFloat tabHeaderHeight;


@end

@implementation MineOrderDetailController

- (instancetype)initWithOrderShopId:(NSString *)shopId
{
    if (self = [super init]) {
        self.shopId = shopId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self hideNavigationBar];
    [self hideTabBar];
    
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self loadDataWithShopId:self.shopId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUIWithModel:(OrderDetailModel *)model
{
    self.titleView = [self addTitleViewWithTitle:@"订单详情"];
    
    [self addGoodsListView];
}

// 商品列表
- (void)addGoodsListView
{
    UITableView *listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.orderListView = listView;
    listView.tableHeaderView = [self getTableHeaderView];
    [listView setDataSource:self];
    [listView setDelegate:self];
    listView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [listView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:listView];
    [listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(1);
    }];
}

- (UIView *)getTableHeaderView
{
    UIView *headerView = [[UIView alloc] init];
    [headerView setBackgroundColor:viewControllerBgColor];
    
    CGFloat infoVieHeight = fScreen(172);
    [self addInfoViewWithModel:self.orderDetailModel superView:headerView];
    
    CGFloat detailViewHeight = [self addInfoDetailViewWithModel:self.orderDetailModel superView:headerView];
    
    self.tabHeaderHeight = infoVieHeight + fScreen(20) + detailViewHeight;
    
    [headerView setFrame:CGRectMake(0, 0, kAppWidth, self.tabHeaderHeight)];
    
    return headerView;
}

// 订单详细信息:金额,地址等
- (CGFloat)addInfoDetailViewWithModel:(OrderDetailModel *)model superView:(UIView *)superView
{
    UIView *orderDetailView = [[UIView alloc] init];
    [orderDetailView setBackgroundColor:[UIColor whiteColor]];
    [superView addSubview:orderDetailView];
    self.orderDetailInfoView = orderDetailView;
    
    
    NSDictionary *titleAttri = @{NSForegroundColorAttributeName : HexColor(0x666666)};
    CGFloat textHeight = [@"高度" sizeForFontsize:fScreen(24)].height;
    
    // 支付金额
    UILabel *payLabel = [[UILabel alloc] init];
    [payLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    NSMutableAttributedString *payString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"支付金额: ¥%@",model.payMoney]];
    [payString addAttributes:titleAttri range:NSMakeRange(0, 7)];
    NSDictionary *moneyAttri = @{NSForegroundColorAttributeName : HexColor(0xe44a62)};
    [payString addAttributes:moneyAttri range:NSMakeRange(6, payString.length - 6)];
    [payLabel setAttributedText:payString];
    
    [orderDetailView addSubview:payLabel];
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderDetailView.mas_left).offset(fScreen(28));
        make.right.equalTo(orderDetailView.mas_right).offset(-fScreen(50));
        make.top.equalTo(orderDetailView.mas_top).offset(fScreen(30));
        make.height.mas_equalTo(textHeight);
    }];
    
    // 配送方式
    UILabel *sendWayLabel = [[UILabel alloc] init];
    [sendWayLabel setFont:payLabel.font];
    NSMutableAttributedString *sendWayString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"配送方式: %@",model.sendWay]];
    [sendWayString addAttributes:titleAttri range:NSMakeRange(0, 6)];
    NSDictionary *sendWayArri = @{NSForegroundColorAttributeName : HexColor(0x333333)};
    [sendWayString addAttributes:sendWayArri range:NSMakeRange(5, sendWayString.length - 6)];
    [sendWayLabel setAttributedText:sendWayString];
    
    [orderDetailView addSubview:sendWayLabel];
    [sendWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(payLabel);
        make.top.equalTo(payLabel.mas_bottom).offset(fScreen(16));
    }];
    
    // 收货地址
    UILabel *addrTitleLabel = [[UILabel alloc] init];
    [addrTitleLabel setText:@"收货地址: "];
    [addrTitleLabel setFont:sendWayLabel.font];
    [addrTitleLabel setTextColor:HexColor(0x666666)];
    [orderDetailView addSubview:addrTitleLabel];
    [addrTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(sendWayLabel);
        make.top.equalTo(sendWayLabel.mas_bottom).offset(fScreen(16));
        CGSize textSize = [addrTitleLabel.text sizeForFontsize:fScreen(24)];
        make.width.mas_equalTo(textSize.width + 2);
    }];
    
    HDLabel *addrLabel = [[HDLabel alloc] init];
    [addrLabel setFont:addrTitleLabel.font];
    [addrLabel setNumberOfLines:0];
    [addrLabel setTextColor:HexColor(0x333333)];
    
    NSAttributedString *addrString = [NSAttributedString getAttributeString:model.address lineSpacing:fScreen(16)];
    NSMutableAttributedString *addrString2 = [[NSMutableAttributedString alloc] initWithAttributedString:addrString];
    NSDictionary *fontAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]};
    [addrString2 addAttributes:fontAttr range:NSMakeRange(0, addrString.length)];
    
    [addrLabel setAttributedText:addrString2];
    
    addrLabel.width = kAppWidth - fScreen(28 + 50) - [addrTitleLabel.text sizeForFontsize:fScreen(24)].width;
    CGFloat addrLabelHeight = addrLabel.textHeight;
    BOOL isOneLine = (addrLabelHeight - fScreen(16)) == [@"高度" sizeForFontsize:fScreen(24)].height;
    if (isOneLine) {
        [addrLabel setText:model.address];
    }
    
    [orderDetailView addSubview:addrLabel];
    [addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrTitleLabel.mas_right).offset(-2);
        make.right.equalTo(orderDetailView.mas_right).offset(-fScreen(50));
        make.top.equalTo(addrTitleLabel.mas_top).offset(-1);
        
        if (isOneLine) {
            make.height.mas_equalTo([@"高度" sizeForFontsize:fScreen(24)].height);
        }
        else {
            make.height.mas_equalTo(addrLabelHeight + fScreen(16/2));
        }
    }];
    
    // 收货人
    UILabel *buyerLabel = [[UILabel alloc] init];
    [buyerLabel setFont:payLabel.font];
    NSMutableAttributedString *buyerString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"收货人: %@",model.buyer]];
    NSDictionary *buyerTitleAttr = @{NSForegroundColorAttributeName : HexColor(0x666666)};
    NSDictionary *buyerAttr = @{NSForegroundColorAttributeName :HexColor(0x333333)};
    [buyerString addAttributes:buyerTitleAttr range:NSMakeRange(0, 5)];
    [buyerString addAttributes:buyerAttr range:NSMakeRange(4, buyerString.length - 5)];
    [buyerLabel setAttributedText:buyerString];
    [orderDetailView addSubview:buyerLabel];
    [buyerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderDetailView.mas_left).offset(fScreen(54));
        make.right.equalTo(payLabel.mas_right);
        make.height.mas_equalTo(textHeight);
        make.top.equalTo(addrLabel.mas_bottom).offset(fScreen(16));
    }];
    
    // 高度 = 上下边距 30 + 3个行间距 16 + 地址以外3个选项的文字高度 + 地址的高度
    CGFloat viewHeight = fScreen(30 + 30) + fScreen(16 * 3) + 3*textHeight;
    if (isOneLine) {
        viewHeight += [@"高度" sizeForFontsize:fScreen(24)].height;
    }
    else {
        viewHeight += addrLabelHeight;
    }
    
    [orderDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(superView);
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(viewHeight);
    }];
    
    return viewHeight;
}

// 订单信息:订单号等
- (void)addInfoViewWithModel:(OrderDetailModel *)detailModel superView:(UIView *)superView
{
    UIView *orderInfoView = [[UIView alloc] init];
    [orderInfoView setBackgroundColor:HexColor(0xff605f)];
    [superView addSubview:orderInfoView];
    [orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.left.right.equalTo(superView);
        make.height.mas_equalTo(fScreen(172));
    }];
    self.orderInfoView = orderInfoView;
    
    UILabel *orderStateTitleLabel = [[UILabel alloc] init];
    [orderStateTitleLabel setText:detailModel.orderInfoTitle];
    [orderStateTitleLabel setTextColor:[UIColor whiteColor]];
    [orderStateTitleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [self.orderInfoView addSubview:orderStateTitleLabel];
    [orderStateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.orderInfoView.mas_left).offset(fScreen(28));
        make.right.equalTo(self.orderInfoView.mas_right);
        make.top.equalTo(self.orderInfoView.mas_top).offset(fScreen(30));
        CGSize textSize = [orderStateTitleLabel.text sizeForFontsize:fScreen(32)];
        make.height.mas_equalTo(textSize.height);
    }];
    
    CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
    
    UILabel *SNLabel = [[UILabel alloc] init];
    [SNLabel setTextColor:[UIColor whiteColor]];
    [SNLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    NSString *snString = [NSString stringWithFormat:@"订单编号: %@",detailModel.orderSN];
    [SNLabel setText:snString];
    [self.orderInfoView addSubview:SNLabel];
    [SNLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(orderStateTitleLabel);
        make.top.equalTo(orderStateTitleLabel.mas_bottom).offset(fScreen(11));
        make.height.mas_equalTo(textSize.height);
    }];
    
    UILabel *orderTimeLabel = [[UILabel alloc] init];
    [orderTimeLabel setFont:SNLabel.font];
    [orderTimeLabel setTextColor:[UIColor whiteColor]];
    NSString *orderTimeString = [NSString stringWithFormat:@"下单时间: %@",detailModel.orderTime];
    [orderTimeLabel setText:orderTimeString];
    [self.orderInfoView addSubview:orderTimeLabel];
    [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(SNLabel);
        make.top.equalTo(SNLabel.mas_bottom).offset(fScreen(11));
    }];
}

- (void)loadDataWithShopId:(NSString *)shopId
{
    // 请求数据
    // 模拟数据
    OrderShopModel *shopModel = [[OrderShopModel alloc] init];
    shopModel.goodsCount = 3;
    shopModel.goodsAmount = @"123.45";
    shopModel.shopName = [NSString stringWithFormat:@"订单列表测试店铺名- NO.1"];
    shopModel.state = OrderShopState_NoShow;
    
    NSMutableArray *goodsTmpArray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < 4; index++) {
        OrderModel *model = [[OrderModel alloc] init];
        model.goodsName = @"测试店铺的测试商品名称,阿拉拉啦啦啦";
        model.goodsSpecification = @"测试规格";
        model.goodsPrice = @"12.4";
        model.goodsNumber = 2;
        if (index == 1) {
            model.goodsLimitNumber = 1;
            model.goodsNumber = 1;
        }
        if (index == 2) {
            model.isGroup = YES;
            model.groupInfoTitle = @"水果";
        }
        
        [goodsTmpArray addObject:model];
    }
    shopModel.goodsArray = [goodsTmpArray copy];
    
    OrderDetailModel *detailModel = [[OrderDetailModel alloc] init];
    
    detailModel.orderInfoTitle = @"等待卖家发货";
    detailModel.orderSN = @"23333455555555";
    detailModel.orderTime = @"2016-10-29 14:20:22";
    detailModel.payMoney = @"123.45";
    detailModel.sendWay = @"快递配送";
    detailModel.address = @"福建省厦门市思明区软件园二期望海路63之一二楼G单元";//@"福建省厦门市思明区软件园";
    detailModel.buyer = @"厦门吴彦祖 18695696529";
    detailModel.shopModel = shopModel;
    
    detailModel.isGroupMasterFree = YES;
    detailModel.note = @"不发两个红包不给好评";
    detailModel.numCount = 3;
    detailModel.isGroup = YES;
    
    self.orderDetailModel = detailModel;
    
    // 请求数据后更改 UI
    [self initUIWithModel:self.orderDetailModel];
    
    if (self.orderDetailModel.isGroup) {
        UIButton *shareButton = [[UIButton alloc] init];
        [shareButton setTitle:@"分享拼团" forState:UIControlStateNormal];
        [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [shareButton setBackgroundColor:HexColor(0xe44a62)];
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.mas_equalTo(fScreen(88));
        }];
        
        [self.orderListView setContentInset:UIEdgeInsetsMake(0, 0, fScreen(100), 0)];
    }
    
}

- (void)backbuttonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderDetailModel.shopModel.goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[MineOrderTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    OrderModel *model = (OrderModel *)[self.orderDetailModel.shopModel.goodsArray objectAtIndex:indexPath.row];
    
    cell.orderModel = model;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MineOrderTabHeaderView *header = [[MineOrderTabHeaderView alloc] init];
    header.orderShopModel = self.orderDetailModel.shopModel;
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (self.orderDetailModel.isGroupMasterFree) {
        MineGroupOrderDetailTabFooterView *footerView = [[MineGroupOrderDetailTabFooterView alloc] initWithNote:self.orderDetailModel.note count:self.orderDetailModel.numCount pay:self.orderDetailModel.payMoney isMster:self.orderDetailModel.isGroupMasterFree];
        return footerView;
    }
    else {
        MineOrderDetailTabFooterView *footerView = [[MineOrderDetailTabFooterView alloc] init];
        footerView.payMoney = self.orderDetailModel.payMoney;
        return footerView;
    }
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
    if (self.orderDetailModel.isGroupMasterFree) {
        HDLabel *noteLabel = [[HDLabel alloc] init];
        [noteLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
        [noteLabel setTextColor:HexColor(0x999999)];
        [noteLabel setText:self.orderDetailModel.note];
        [noteLabel setLineSpace:fScreen(10)];
        [noteLabel setWidth:kAppWidth - fScreen(28*2) - fScreen(140)];
        [noteLabel setAdjustsFontSizeToFitWidth:YES];
        [noteLabel setNumberOfLines:0];
        return fScreen(80*3 - 10) + noteLabel.textHeight - fScreen(26);
    }
    else {
        return fScreen(68 - 10);
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderModel *model = (OrderModel *)[self.orderDetailModel.shopModel.goodsArray objectAtIndex:indexPath.row];
    
    if (model.isGroup) {
        GroupbuyOrderController *groupBuyVC = [[GroupbuyOrderController alloc] initWithTitle:model.groupInfoTitle groupId:model.groupId];
        [self.navigationController pushViewController:groupBuyVC animated:YES];
    }
    else {

        GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:model.goodsId];
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
}

- (void)shareButtonClick:(UIButton *)sender
{
    ShareView *shareView = [[ShareView alloc] init];
    [self.view addSubview:shareView];
    shareView.shareModel = self.orderDetailModel.shareModel;
    shareView.currNaviController = self.navigationController;
}

@end


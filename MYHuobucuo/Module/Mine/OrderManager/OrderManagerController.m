//
//  OrderManagerController.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "OrderManagerController.h"
#import <Masonry.h>
#import "MineOrderTabCell.h"
#import "HDRefresh.h"
#import "OrderShopModel.h"
#import "OrderModel.h"
#import "MineOrderTabHeaderView.h"
#import "MineOrderTabFooterView.h"
#import "MineOrderDetailController.h"
#import "ReviewsController.h"

@interface OrderManagerController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *itemView;
@property (nonatomic, strong) UIView *currItemLine;
@property (nonatomic, strong) UITableView *orderListView;
@property (nonatomic, strong) UIButton *currButton;
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, assign) MineOrderType orderType;
@property (nonatomic, assign) NSUInteger currPage;
@property (nonatomic, strong) NSArray *shopModelArray;  // 店铺的数组 每个元素是 OrderShopModel 对象

@end

@implementation OrderManagerController

- (instancetype)init
{
    if (self = [super init]) {
        self.orderType = MineOrderType_All; // 默认是全部
    }
    return self;
}

- (instancetype)initWithOrderType:(MineOrderType)orderType
{
    if (self = [super init]) {
        self.orderType = orderType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self hideTabBar];
    [self hideNavigationBar];
    
    [self.view setBackgroundColor:viewControllerBgColor];
    
    // title
    [self addTitleView];
    
    [self addItemView];
    
    [self.view addSubview:self.orderListView];
    [self.orderListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.itemView.mas_bottom);
    }];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    [self.emptyView setHidden:YES];
    
    // 加载数据
    [self refreshListDataWithOrderType:MineOrderType_WaitPay];
}

- (void)addItemView
{
    UIView *itemView = [[UIView alloc] init];
    [itemView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom).offset(1);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(90));
    }];
    self.itemView = itemView;
    
    CGFloat width = kAppWidth/5;
    CGFloat x = 0;
    
    NSArray *titleArray = @[@"全部的", @"待付款", @"待发货", @"待收货", @"待评价"];
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *button = [[UIButton alloc] init];
        [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [button addTarget:self action:@selector(itemButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
        [button setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
        [button setFrame:CGRectMake(x, 0, width, fScreen(90))];
        
        if (index == self.orderType) {
            [button setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
            self.currButton = button;
        }
        
        [itemView addSubview:button];
        
        if (index != 4) {
            UIView *line = [[UIView alloc] init];
            [line setBackgroundColor:self.view.backgroundColor];
            [line setFrame:CGRectMake(x + width - 1, fScreen((90 - 26)/2), 1, fScreen(26))];
            [itemView addSubview:line];
        }
        
        x += width;
    }
    
    if (!self.currItemLine) {
        self.currItemLine = [[UIView alloc] init];
        [self.currItemLine setBackgroundColor:HexColor(0xe44a62)];
        [itemView addSubview:self.currItemLine];
        
        CGFloat x;
        switch (self.orderType) {
            case MineOrderType_All:
                x = 0;
                break;
            case MineOrderType_WaitPay:
                x = width;
                break;
            case MineOrderType_WaitSend:
                x = 2 * width;
                break;
            case MineOrderType_WaitReceive:
                x = 3 * width;
                break;
            case MineOrderType_WaitEvaluate:
                x = 4 * width;
                break;
            default:
                x = 0;
                break;
        }
        [self.currItemLine setFrame:CGRectMake(x, fScreen(90 - 4), width, fScreen(4))];
    }
}

- (void)addTitleView
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88) + 20);
    }];
    self.titleView = titleView;
    
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"jiantou-(1)"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.centerY.equalTo(titleView.mas_centerY).offset(10);
        make.height.mas_equalTo(fScreen(38));
        make.width.mas_equalTo(fScreen(28*2 + 38));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:viewControllerTitleFontSize]];
    [titleLabel setText:@"订单管理"];
    [titleLabel setTextColor:viewControllerTitleColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
        make.centerY.equalTo(backButton.mas_centerY);
        CGSize textSize = [titleLabel.text sizeForFontsize:viewControllerTitleFontSize];
        make.height.mas_equalTo(textSize.height);
        make.width.mas_equalTo(textSize.width + 4);
    }];
}

- (void)setCurrSelectItem:(UIButton *)button
{
    [self.currButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [button setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    self.currButton = button;
    
    CGRect frame = self.currItemLine.frame;
    frame.origin.x = button.frame.origin.x;
    [self.currItemLine setFrame:frame];
}

- (void)refreshListDataWithOrderType:(MineOrderType)type
{
    self.currPage = 0;
    
    // 模拟数据
    NSMutableArray *shopTmpArray = [NSMutableArray array];
    
    for (NSInteger shopIndex = 0; shopIndex < 3; shopIndex++) {
        OrderShopModel *shopModel = [[OrderShopModel alloc] init];
        shopModel.goodsCount = 3;
        shopModel.goodsAmount = @"123.45";
        shopModel.shopName = [NSString stringWithFormat:@"订单列表测试店铺名- NO.%ld",shopIndex];
        
        OrderShopState state;
        switch (self.orderType) {
            case MineOrderType_WaitPay:
                state = OrderShopState_WaitPay;
                break;
            case MineOrderType_WaitSend:
                state = OrderShopState_WaitSend;
                break;
            case MineOrderType_WaitReceive:
                state = OrderShopState_WaitReceive;
                break;
            case MineOrderType_WaitEvaluate:
                state = OrderShopState_WaitEvaluate;
                break;
                
            default:
                state = OrderShopState_NoShow;
                break;
        }
        shopModel.state = state;
        
        
        NSMutableArray *goodsTmpArray = [NSMutableArray array];
        
        for (NSInteger index = 0; index < 2; index++) {
            OrderModel *model = [[OrderModel alloc] init];
            model.goodsName = @"测试店铺的测试商品名称,阿拉拉啦啦啦";
            model.goodsSpecification = @"测试规格";
            model.goodsPrice = @"12.4";
            model.goodsNumber = 2;
            if (index == 1) {
                model.goodsLimitNumber = 1;
                model.goodsNumber = 1;
            }
            
            [goodsTmpArray addObject:model];
        }
        shopModel.goodsArray = [goodsTmpArray copy];
        
        [shopTmpArray addObject:shopModel];
    }
    self.shopModelArray = [shopTmpArray copy];
    [self.orderListView reloadData];
    
    [self.orderListView.mj_header endRefreshing];
}

- (void)loadMoreListDataWithOrderType:(MineOrderType)type currPage:(NSUInteger)currPage
{
    
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.shopModelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderShopModel *model = [self.shopModelArray objectAtIndex:section];
    NSArray *goodsArray = model.goodsArray;
    return [goodsArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[MineOrderTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    OrderShopModel *shopModel = [self.shopModelArray objectAtIndex:indexPath.section];
    OrderModel *model = [shopModel.goodsArray objectAtIndex:indexPath.row];
    
    [cell setOrderModel:model];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderShopModel *shopM0del = [self.shopModelArray objectAtIndex:section];
    MineOrderTabHeaderView *header = [[MineOrderTabHeaderView alloc] init];
    [header setOrderShopModel:shopM0del];
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    OrderShopModel *shopModel = [self.shopModelArray objectAtIndex:section];
    MineOrderTabFooterView *footer = [[MineOrderTabFooterView alloc] init];
    [footer setOrderShopModel:shopModel];
    
    __weak typeof(self) weakSelf = self;
    footer.rightButtonBlock = ^(OrderShopState state) {
        
        UIViewController *toVC;
        switch (state) {
            case OrderShopState_WaitEvaluate:
            case OrderShopState_WaitReceive:
                // 确认收货和待评价都跳转评价界面
            {
                ReviewsController *reviewVC = [[ReviewsController alloc] initWithOrderModel:shopModel];
                toVC = reviewVC;
            }
                break;
            case OrderShopState_WaitPay:
                break;
            case OrderShopState_WaitSend:
                break;
                
            default:
                break;
        }
        
        if (toVC) {
            [weakSelf.navigationController pushViewController:toVC animated:YES];
        }
    };
    return footer;
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
    return kMineOrderTabFooterHeight;   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MineOrderDetailController *orderDetailController = [[MineOrderDetailController alloc] init];
    [self.navigationController pushViewController:orderDetailController animated:YES];
}


#pragma mark - Button Click
- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)itemButtonClick:(UIButton *)sender
{
    [self setCurrSelectItem:sender];
    
    // 列表改变
    
}

#pragma mark - Getter
- (UITableView *)orderListView
{
    if (!_orderListView) {
        
        _orderListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_orderListView setDataSource:self];
        [_orderListView setDelegate:self];
        _orderListView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        __weak typeof(self) weakSelf = self;
        
        // 下拉刷新,上拉加载
        self.currPage = 0;
        
        _orderListView.mj_header = [RefreshHeader headerWithTitle:@"哎呀,被发现了" freshingTitle:@"玩命刷新中..." freshBlock:^{
            [weakSelf refreshListDataWithOrderType:weakSelf.orderType];
        }];
        
        _orderListView.mj_footer = [RefreshFooter footerWithTitle:@"够胆上拉我试试看" uploadingTitle:@"玩命加载中..." noMoreTitle:@"别拉了,都在这儿了" uploadBlock:^{
            [weakSelf loadMoreListDataWithOrderType:weakSelf.orderType currPage:weakSelf.currPage++];
        }];
    }
    return _orderListView;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        UIView *bgView = [[UIView alloc] init];
        [bgView setBackgroundColor:self.view.backgroundColor];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"img_dingdan_kong@3x.png" ofType:nil];
        UIImageView *emptyImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];
        [bgView addSubview:emptyImageView];
        [emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(fScreen(240));
            make.width.mas_equalTo(fScreen(298));
            make.top.equalTo(bgView.mas_top).offset(fScreen(220));
            make.centerX.equalTo(bgView.mas_centerX);
        }];
        
        _emptyView = bgView;
    }
    return _emptyView;
}

@end

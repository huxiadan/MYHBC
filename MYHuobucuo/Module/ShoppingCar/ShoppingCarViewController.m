//
//  ShoppingCarViewController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "ShoppingCarViewController.h"

#import <Masonry.h>
#import "ShoppingCarTabCell.h"
#import "OrderModel.h"
#import "OrderShopModel.h"
#import "ShoppingCarModel.h"
#import "ShoppingCarHeaderView.h"
#import "MYSingleTon.h"
#import "GoodsViewController.h"
#import "StoreViewController.h"
#import "NetworkRequest.h"

#define kPageSize 15

@interface ShoppingCarViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *editButton;          // 编辑按钮
@property (nonatomic, strong) UITableView *shopCarListView;
@property (nonatomic, strong) UIView *bottomView;            // 底部付款视图
@property (nonatomic, strong) UIButton *selectAllButton;     // 全选按钮
@property (nonatomic, strong) UILabel *payNumberLabel;       // 共计
@property (nonatomic, strong) UILabel *payMoneyLabel;        // 总价
@property (nonatomic, strong) UIButton *payButton;           // 付款按钮/全部编辑删除按钮
@property (nonatomic, strong) UIView *emptyView;             // 空购物车视图

@property (nonatomic, strong) ShoppingCarModel *shopCarModel;// 购物车模型
@property (nonatomic, assign) BOOL isShowTabBar;             // 是否显示 tabbar. 适配两种情况下的购物车
@property (nonatomic, assign) BOOL isEditAll;                // 全部 cell 进入编辑状态
@property (nonatomic, assign) NSUInteger currPageNumber;     // 当前页数

@end

@implementation ShoppingCarViewController

#pragma mark - life cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    self.isShowTabBar ? [self showTabBar] : [self hideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestData];
    
    [self initUI];
    
//    [self emptyData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public
- (instancetype)initWithShowTabBar:(BOOL)showTabBar
{
    if (self = [super init]) {
        self.isShowTabBar = showTabBar;
    }
    return self;
}

#pragma mark - Private

- (void)requestData
{
    // 请求数据
    ShoppingCarModel *shopCarModel = [[ShoppingCarModel alloc] init];
    shopCarModel.payNumberCount = 5;
    shopCarModel.payMoneyCount = @"1243.6";
    shopCarModel.isSelectAll = YES;
    
    NSMutableArray *shopTmpArray = [NSMutableArray array];
    
    for (NSInteger shopIndex = 0; shopIndex < 3; shopIndex++) {
        OrderShopModel *shopModel = [[OrderShopModel alloc] init];
        shopModel.goodsCount = 3;
        shopModel.goodsAmount = @"123.45";
        shopModel.shopName = [NSString stringWithFormat:@"订单列表测试店铺名- NO.%ld",shopIndex];
        shopModel.state = OrderShopState_WaitPay;
        shopModel.isSelect = NO;
        
        NSMutableArray *goodsTmpArray = [NSMutableArray array];
        
        for (NSInteger index = 0; index < 2; index++) {
            OrderModel *model = [[OrderModel alloc] init];
            model.goodsName = @"测试店铺的测试商品名称,阿拉拉啦啦啦";
            model.goodsSpecification = @"测试规格";
            model.goodsPrice = @"12.4";
            model.goodsNumber = 2;
            model.isSelect = NO;
            if (index == 1) {
                model.goodsLimitNumber = 1;
                model.goodsNumber = 1;
            }
            
            [goodsTmpArray addObject:model];
        }
        shopModel.goodsArray = [goodsTmpArray copy];
        
        [shopTmpArray addObject:shopModel];
    }
    shopCarModel.shopArray = [shopTmpArray copy];
    
    [MYSingleTon sharedMYSingleTon].shoppingCarModel = shopCarModel;
    
    [self.shopCarListView reloadData];

    [self setPayNumberLabelText:shopCarModel.payNumberCount];
    [self setPayMoneyLabelText:shopCarModel.payMoneyCount];
    self.selectAllButton.selected = shopCarModel.isSelectAll;
}

- (void)refreshShoppingCarData
{
    [MYSingleTon sharedMYSingleTon].shoppingCarModel = nil;
    
    self.currPageNumber = 0;
    
    [self requestDataWithPage:0];
    
}

- (void)loadMoreShoppingCarData
{
    self.currPageNumber++;
    
    [self requestDataWithPage:self.currPageNumber];
}

- (void)requestDataWithPage:(NSUInteger)page
{
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager getShoppingCarInfoWithPage:page pageSize:kPageSize finishBlock:^(id jsonData, NSError *error) {
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
                
                [weakSelf.payNumberLabel setText:[dataDict objectForKey:@"allnum"]];
                [weakSelf.payMoneyLabel setText:[dataDict objectForKey:@"allprice"]];
            }
        }
    }];
}

- (void)emptyData
{
    [self.editButton setHidden:YES];
    [self.emptyView setHidden:NO];
}

- (void)hasData
{
    [self.editButton setHidden:NO];
    [self.emptyView setHidden:YES];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self addTitleView];
    
    [self.view addSubview:self.shopCarListView];
    [self.shopCarListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self.view);
        if (self.isShowTabBar) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-(49 + fScreen(114)));
        }
        else {
            make.bottom.equalTo(self.view.mas_bottom).offset(-fScreen(114));
        }
    }];

    [self addBottomView];
    
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom);
    }];
    [self.emptyView setHidden:YES];
}

- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(self.isShowTabBar ? -49 : 0);
        make.height.mas_equalTo(fScreen(110));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bottomView);
        make.height.equalTo(@1);
    }];
    
    UIButton *selectAllButton = [[UIButton alloc] init];
    [selectAllButton setImage:[UIImage imageNamed:@"icon_choose_s"] forState:UIControlStateSelected];
    [selectAllButton setImage:[UIImage imageNamed:@"icon_choose_n"] forState:UIControlStateNormal];
    [selectAllButton addTarget:self action:@selector(selectAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:selectAllButton];
    [selectAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left);
        make.centerY.equalTo(bottomView.mas_centerY);
        make.width.mas_equalTo(fScreen(28*2 + 40));
        make.height.mas_equalTo(fScreen(40 + 10*2));
    }];
    self.selectAllButton = selectAllButton;
    
    
    UILabel *selectAllLabel = [[UILabel alloc] init];
    [selectAllLabel setText:@"全选"];
    [selectAllLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [selectAllLabel setTextColor:HexColor(0x666666)];
    [bottomView addSubview:selectAllLabel];
    [selectAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectAllButton.mas_right).offset(fScreen(2));
        make.centerY.equalTo(selectAllButton.mas_centerY);
        make.top.bottom.equalTo(bottomView);
    }];
    
    UIButton *payButton = [[UIButton alloc] init];
    [payButton setTitle:@"付款" forState:UIControlStateNormal];
    [payButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setBackgroundColor:HexColor(0xe44a62)];
    [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(bottomView);
        make.width.mas_equalTo(fScreen(218));
    }];
    self.payButton = payButton;
    
    UILabel *payNumberLabel = [[UILabel alloc] init];
    [payNumberLabel setText:@"共计0件"];
    [payNumberLabel setTextColor:HexColor(0x666666)];
    [payNumberLabel setTextAlignment:NSTextAlignmentRight];
    [payNumberLabel setFont:[UIFont systemFontOfSize:fScreen(30)]];
    [bottomView addSubview:payNumberLabel];
    [payNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(payButton.mas_left).offset(-fScreen(30));
        make.top.equalTo(bottomView.mas_top).offset(fScreen(18));
        make.left.equalTo(selectAllLabel.mas_right).offset(fScreen(30));
        CGSize textSize = [payNumberLabel.text sizeForFontsize:fScreen(32)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.payNumberLabel = payNumberLabel;
    
    
    UILabel *payMoneyLabel = [[UILabel alloc] init];
    [payMoneyLabel setFont:[UIFont systemFontOfSize:fScreen(30)]];
    [payMoneyLabel setTextAlignment:NSTextAlignmentRight];
    [bottomView addSubview:payMoneyLabel];
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(payNumberLabel);
        make.bottom.equalTo(bottomView.mas_bottom).offset(-fScreen(18));
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(30)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.payMoneyLabel = payMoneyLabel;
}

- (void)addTitleView
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(fScreen(40 + 88));
    }];
    self.titleView = titleView;
    
    if (!self.isShowTabBar) {
        UIButton *backButton = [self makeBackButton];
        [titleView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleView.mas_left);
            make.centerY.equalTo(titleView.mas_centerY).offset(fScreen(20));
            make.height.mas_equalTo(fScreen(38));
            make.width.mas_equalTo(fScreen(28*2 + 38));
        }];
    }
    
    UILabel *titleLabel = [self makeTitleLabelWithTitle:@"购物车"];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleView.mas_centerX);
        make.centerY.equalTo(titleView.mas_centerY).offset(fScreen(20));
        make.width.mas_equalTo(titleLabel.frame.size.width);
        make.height.mas_equalTo(titleLabel.frame.size.height);
    }];
    
    UIButton *editButton = [[UIButton alloc] init];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    CGSize textSize = [editButton.titleLabel.text sizeForFontsize:fScreen(32)];
    [titleView addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(titleView.mas_right);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.height.mas_equalTo(textSize.height);
        make.width.mas_equalTo(textSize.width + fScreen(28)*2);
    }];
    
    self.editButton = editButton;
    
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(titleView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - Button click
- (void)editButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [MYSingleTon sharedMYSingleTon].shoppingCarModel.isEditAll = YES;
        [self.payNumberLabel setHidden:YES];
        [self.payMoneyLabel setHidden:YES];
        [self.payButton setTitle:@"删除" forState:UIControlStateNormal];
    }
    else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [MYSingleTon sharedMYSingleTon].shoppingCarModel.isEditAll = NO;
        [self.payNumberLabel setHidden:NO];
        [self.payMoneyLabel setHidden:NO];
        [self.payButton setTitle:@"结算" forState:UIControlStateNormal];
    }
    [self.shopCarListView reloadData];
}

- (void)selectAllButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    [MYSingleTon sharedMYSingleTon].shoppingCarModel.isSelectAll = sender.isSelected;
    
    [self.shopCarListView reloadData];
}

- (void)payButtonClick:(UIButton *)sender
{
    
}

#pragma mark - tableView dataSource & delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[MYSingleTon sharedMYSingleTon].shoppingCarModel.shopArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    OrderShopModel *shopModel = [[MYSingleTon sharedMYSingleTon].shoppingCarModel.shopArray objectAtIndex:section];
    return [shopModel.goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoppingCarTabCell *cell = [tableView dequeueReusableCellWithIdentifier:kShoppingCarTabCellIdentity];
    
    if (!cell) {
        cell = [[ShoppingCarTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kShoppingCarTabCellIdentity];
        cell.indexPath = indexPath;
    }
    
    OrderShopModel *shopModel = [[MYSingleTon sharedMYSingleTon].shoppingCarModel.shopArray objectAtIndex:indexPath.section];
    OrderModel *orderModel = [shopModel.goodsArray objectAtIndex:indexPath.row];
    cell.orderModel = orderModel;
    
    __weak typeof(self) weakSelf = self;
    cell.selectBlock = ^(OrderModel *model) {
        
        [[MYSingleTon sharedMYSingleTon] updateShoppingCarDataWithSection:indexPath.section actionSender:1];
        
        [weakSelf.shopCarListView reloadData];
    };
    cell.deleteBlock = ^(OrderModel *model) {
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[MYSingleTon sharedMYSingleTon].shoppingCarModel.shopArray];
        
        for (OrderShopModel *shopCarModel in tmpArray) {
            BOOL hasRemove = NO;
            for (OrderModel *obj in shopCarModel.goodsArray) {
                if (obj == model) {
                    NSMutableArray *tmpShopArray = [NSMutableArray arrayWithArray:shopCarModel.goodsArray];
                    [tmpShopArray removeObject:model];
                    shopCarModel.goodsArray = [tmpShopArray copy];
                    break;
                }
            }
            if (hasRemove) {
                break;
            }
        }

        [MYSingleTon sharedMYSingleTon].shoppingCarModel.shopArray = [tmpArray copy];
        
        [weakSelf.shopCarListView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [weakSelf.shopCarListView reloadData];
    };
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShoppingCarHeaderView *headerView = [[ShoppingCarHeaderView alloc] init];
    
    OrderShopModel *shopModel = [[MYSingleTon sharedMYSingleTon].shoppingCarModel.shopArray objectAtIndex:section];
    headerView.shopModel = shopModel;
    
    __weak typeof(self) weakSelf = self;
    headerView.selectAllBlock = ^() {
        [weakSelf.shopCarListView reloadData];
    };
    headerView.editBlock = ^() {
        [weakSelf.shopCarListView reloadData];
    };
    headerView.storeBlock = ^(NSString *shopId) {
        StoreViewController *storeVC = [[StoreViewController alloc] initWithShopId:shopId];
        [weakSelf.navigationController pushViewController:storeVC animated:YES];
    };
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kShoppingCarHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kShoppingCarTabCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OrderShopModel *shopModel = [self.shopCarModel.shopArray objectAtIndex:indexPath.section];
    OrderModel *orderModel = [shopModel.goodsArray objectAtIndex:indexPath.row];
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:orderModel.goodsId];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - Getter
- (UITableView *)shopCarListView
{
    if (!_shopCarListView) {
        _shopCarListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_shopCarListView setDataSource:self];
        [_shopCarListView setDelegate:self];
        _shopCarListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _shopCarListView;
}

- (UIView *)emptyView
{
    if (!_emptyView) {
        UIView *bgView = [[UIView alloc] init];
        [bgView setBackgroundColor:self.view.backgroundColor];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"img_gouwuche_kong@3x.png" ofType:nil];
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

#pragma mark - Setter
- (void)setPayNumberLabelText:(NSUInteger)number
{
    NSString *text = [NSString stringWithFormat:@"共计%ld件",number];
    [self.payNumberLabel setText:text];
}

- (void)setPayMoneyLabelText:(NSString *)text
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总价:  ¥%@",text]];
    NSDictionary *attr = @{NSForegroundColorAttributeName : HexColor(0x666666)};
    NSDictionary *attr2 = @{NSForegroundColorAttributeName : HexColor(0xe44a62)};
    [attrString addAttributes:attr range:NSMakeRange(0, 5)];
    [attrString addAttributes:attr2 range:NSMakeRange(5, attrString.length - 5)];
    
    [self.payMoneyLabel setAttributedText:attrString];
}

@end

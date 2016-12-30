//
//  MineViewController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "MineViewController.h"

#import "MYTabBarController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "MyWalletViewController.h"
#import "OrderManagerController.h"
#import "SettingViewController.h"
#import "AddressController.h"
#import "CollectionGoodsController.h"
#import "CollectionShopController.h"
#import "UserInfoViewController.h"

#import "NetworkRequest.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>


#define MineOtherButtonTag 1000

@interface MineViewController ()

@property (nonatomic, strong) UIView *userInfoView;         // 顶部用户信息
@property (nonatomic, strong) UIView *userOrderView;        // 用户订单
@property (nonatomic, strong) UIView *userOtherView;        // 其他相关(我的钱包等)

@property (nonatomic, strong) UIImageView *userIconImageView;     // 用户头像
@property (nonatomic, strong) UILabel *userNameLabel;             // 用户名称
@property (nonatomic, strong) MineUserInfoButton *collGoodsButton;  // 收藏的商品
@property (nonatomic, strong) MineUserInfoButton *collStoreButton;  // 关注的店铺
@property (nonatomic, strong) UILabel *walletMoneyLabel;     // 我的钱包金额

@end

@implementation MineViewController

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    
    [self showTabBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setInitShowUserInfo];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:viewControllerBgColor];

    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIconUpdate) name:kUserHeaderIconChange object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
// 设置用户信息
- (void)setInitShowUserInfo
{
    // 登录/未登录 数据显示处理
    if (![AppUserManager hasUser]) {
        [self.userIconImageView setImage:[UIImage imageNamed:@"组-31"]];
        [self.userNameLabel setText:@"登录/注册"];
        [self.collGoodsButton setNumber:@"0"];
        [self.collStoreButton setNumber:@"0"];
    }
    else {
        // 头像
        NSString *iconUrlString = [NSString stringWithFormat:@"%@", [HDUserDefaults objectForKey:cUserIcon]];
        
//        iconUrlString = @"http://od7puorzt.bkt.clouddn.com/original/2016/08/22/aLitXWDTrJXpsXEwmXDFvHayL4wClvWu.JPG";
        
//        iconUrlString = @"http://b.hiphotos.baidu.com/zhidao/pic/item/902397dda144ad34583cdb30d3a20cf430ad8581.jpg";
        
        [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:iconUrlString] placeholderImage:[UIImage imageNamed:@"组-31"]];
        
        // 用户名
        NSString *userName = [HDUserDefaults objectForKey:cUserName];
        if (userName.length == 0) {
            userName = [NSString stringWithFormat:@"用户%@", [HDUserDefaults objectForKey:cUserid]];
        }
        [self.userNameLabel setText:userName];
        
        // 钱包
        NSString *walletMoney = @"10000.0"; //[HDUserDefaults objectForKey:cUserWalletMoney];
        if (walletMoney) {
            [self.walletMoneyLabel setText:walletMoney];
            CGSize textSize = [walletMoney sizeForFontsize:fScreen(24)];
            [self.walletMoneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(textSize.width + 4);
            }];
            [self.walletMoneyLabel layoutIfNeeded];
        }
    }
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = false;
    
    // userInfoView
    [self.view addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(380));
    }];
    
    
    // userOrderView
    [self.view addSubview:self.userOrderView];
    [self.userOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userInfoView.mas_bottom).offset(fScreen(20));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(288));
    }];
    
    
    // userOtherView
    [self.view addSubview:self.userOtherView];
    [self.userOtherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.userOrderView.mas_bottom).offset(fScreen(20));
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    [self setInitShowUserInfo];
}

- (UIView *)createViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle index:(NSInteger)index
{
    UIView *contentView = [[UIView alloc] init];
    UIImageView *imageView = [[UIImageView alloc] init];
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(fScreen(28));
        make.centerY.equalTo(contentView.mas_centerY);
        make.width.mas_equalTo(fScreen(40));
        make.height.mas_equalTo(fScreen(40));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(20));
        make.centerY.equalTo(imageView.mas_centerY);
        CGSize textSize = [titleLabel.text sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width + 4);
        make.height.mas_equalTo(textSize.height);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [arrowImageView setImage:[UIImage imageNamed:@"更多-(1)"]];
    [contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-fScreen(30));
        make.width.mas_equalTo(fScreen(20));
        make.height.mas_equalTo(fScreen(30));
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    
    if (subTitle) {
        UILabel *subTitleLabel = [[UILabel alloc] init];
        [subTitleLabel setText:subTitle];
        [subTitleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [subTitleLabel setTextColor:HexColor(0x999999)];
        [subTitleLabel setTextAlignment:NSTextAlignmentRight];
        [contentView addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-fScreen(24));
            make.centerY.equalTo(contentView.mas_centerY);
            CGSize textSize = [subTitleLabel.text sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 4);
            make.height.mas_equalTo(textSize.height);
        }];
    }
    else if ([title isEqualToString:@"我的钱包"]) {
        [contentView addSubview:self.walletMoneyLabel];
        [self.walletMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-fScreen(24));
            make.centerY.equalTo(contentView.mas_centerY);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 4);
            make.height.mas_equalTo(textSize.height);
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:self.view.backgroundColor];
    [contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView.mas_left).offset(fScreen(30));
        make.right.bottom.equalTo(contentView);
        make.height.equalTo(@1);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTag:index + MineOtherButtonTag];
    [button addTarget:self action:@selector(otherButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(contentView);
    }];
    
    if ([title isEqualToString:@"我的钱包"]) {
        [imageView setImage:[UIImage imageNamed:@"组-16"]];
    }
    else if ([title isEqualToString:@"我的收货地址"]) {
        [imageView setImage:[UIImage imageNamed:@"组-18"]];
    }
    else if ([title isEqualToString:@"帮助中心"]) {
        [imageView setImage:[UIImage imageNamed:@"icon_help"]];
    }
    
    
    return contentView;
}

// 更新头像/名称
- (void)userIconUpdate
{
    [self.userIconImageView sd_setImageWithURL:[NSURL URLWithString:[HDUserDefaults objectForKey:cUserIcon]]];
}

#pragma mark - Button click

// 用户头像点击事件
- (void)iconButtonClick:(UIButton *)sender
{
    // 如果登录进入用户信息界面
    // 未登录 进入登录界面
    if ([AppUserManager hasUser]) {
        UserInfoViewController *userInfoVC = [[UserInfoViewController alloc] init];
        [self.navigationController pushViewController:userInfoVC animated:YES];
    }
    else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}


// 设置按钮点击
- (void)settingButtonClick:(UIButton *)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

// 收藏的商品点击
- (void)collectionGoodsButtonClick
{
    CollectionGoodsController *collGoodsVC = [[CollectionGoodsController alloc] init];
    [self.navigationController pushViewController:collGoodsVC animated:YES];
}

// 关注的店铺点击
- (void)collectionStoreButtonClick
{
    CollectionShopController *collShopVC = [[CollectionShopController alloc] init];
    [self.navigationController pushViewController:collShopVC animated:YES];
}

// 订单状态相关按钮点击
- (void)orderButtonClick:(id)buttonTitle
{
    MineOrderType type;
    
    if ([buttonTitle isKindOfClass:[UIButton class]]) {
        type = MineOrderType_All;
    }
    else if ([buttonTitle isKindOfClass:[NSString class]]) {
        NSString *title = (NSString *)buttonTitle;
        
        if ([title isEqualToString:@"待付款"]) {
            type = MineOrderType_WaitPay;
        }
        else if ([title isEqualToString:@"待发货"]) {
            type = MineOrderType_WaitSend;
        }
        else if ([title isEqualToString:@"待收货"]) {
            type = MineOrderType_WaitReceive;
        }
        else if ([title isEqualToString:@"待评价"]) {
            type = MineOrderType_WaitEvaluate;
        }
    }
    
    OrderManagerController *orderController = [[OrderManagerController alloc] initWithOrderType:type];
    [self.navigationController pushViewController:orderController animated:YES];
}

// 其他功能 cell 点击
- (void)otherButtonClick:(UIButton *)sender
{
    if (![AppUserManager hasUser]) {
        
        [AppUserManager alertToLogin:self.navigationController];
        
        return;
    }
    
    NSInteger index = sender.tag - MineOtherButtonTag;
    
    switch (index) {
        case 0:
        {
            // 我的钱包
            MyWalletViewController *toViewController = [[MyWalletViewController alloc] init];
            [self.navigationController pushViewController:toViewController animated:YES];
        }
            break;
        case 1:
        {
            // 我的收货地址
            AddressController *addrController = [[AddressController alloc] init];
            [self.navigationController pushViewController:addrController animated:YES];
        }
            break;
        case 2:
        {
            // 帮助中心
            
        }
            
        default:
            break;
    }
}

#pragma mark - Getter

- (UILabel *)walletMoneyLabel
{
    if (!_walletMoneyLabel) {
        _walletMoneyLabel = [[UILabel alloc] init];
        [_walletMoneyLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [_walletMoneyLabel setTextColor:HexColor(0xe79433)];
        [_walletMoneyLabel setTextAlignment:NSTextAlignmentRight];
    }
    return _walletMoneyLabel;
}

- (UIView *)userOtherView
{
    if (!_userOtherView) {
        _userOtherView = [[UIView alloc] init];
        [_userOtherView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *walletView = [self createViewWithTitle:@"我的钱包" subTitle:nil index:0];
        [_userOtherView addSubview:walletView];
        [walletView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_userOtherView);
            make.height.mas_equalTo(fScreen(118 + 1));
        }];
        
        UIView *addressView = [self createViewWithTitle:@"我的收货地址" subTitle:@"查看更多" index:1];
        [_userOtherView addSubview:addressView];
        [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(walletView);
            make.top.equalTo(walletView.mas_bottom);
        }];
        
        UIView *helpView = [self createViewWithTitle:@"帮助中心" subTitle:@"" index:2];
        [_userOtherView addSubview:helpView];
        [helpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.height.equalTo(addressView);
            make.top.equalTo(addressView.mas_bottom);
        }];
    }
    return _userOtherView;
}

- (UIView *)userOrderView
{
    if (!_userOrderView) {
        _userOrderView = [[UIView alloc] init];
        [_userOrderView setBackgroundColor:[UIColor whiteColor]];
        
        // 全部订单
        UIImageView *allOrderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"组-21"]];
        [_userOrderView addSubview:allOrderImageView];
        [allOrderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userOrderView.mas_left).offset(fScreen(30));
            make.width.mas_equalTo(fScreen(40));
            make.height.mas_equalTo(fScreen(40));
            make.centerY.equalTo(_userOrderView.mas_top).offset(fScreen(88)/2);
        }];
        
        UILabel *myOrderLabel = [[UILabel alloc] init];
        [myOrderLabel setText:@"我的订单"];
        [myOrderLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [myOrderLabel setTextColor:HexColor(0x666666)];
        [_userOrderView addSubview:myOrderLabel];
        
        [myOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(allOrderImageView.mas_right).offset(fScreen(22));
            make.centerY.equalTo(allOrderImageView.mas_centerY);
            CGSize textSize = [myOrderLabel.text sizeForFontsize:fScreen(28)];
            make.width.mas_equalTo(textSize.width + 4);
            make.height.mas_equalTo(textSize.height);
        }];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"更多-(1)"]];
        [_userOrderView addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_userOrderView.mas_right).offset(-fScreen(28));
            make.centerY.equalTo(allOrderImageView.mas_centerY);
            make.width.mas_equalTo(fScreen(20));
            make.height.mas_equalTo(fScreen(30));
        }];
        
        UILabel *lookAllLabel = [[UILabel alloc] init];
        [lookAllLabel setText:@"查看全部"];
        [lookAllLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [lookAllLabel setTextColor:HexColor(0x999999)];
        [lookAllLabel setTextAlignment:NSTextAlignmentRight];
        [_userOrderView addSubview:lookAllLabel];
        [lookAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(arrowImageView.mas_left).offset(-fScreen(20));
            make.centerY.equalTo(arrowImageView.mas_centerY);
            CGSize textSize = [lookAllLabel.text sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 4);
            make.height.mas_equalTo(textSize.height);
        }];
        
        UIButton *allOrderButton = [[UIButton alloc] init];
        [allOrderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userOrderView addSubview:allOrderButton];
        [allOrderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_userOrderView);
            make.height.mas_equalTo(fScreen(88));
        }];
        
        // 横线
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:self.view.backgroundColor];
        [_userOrderView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userOrderView.mas_left).offset(fScreen(30));
            make.height.equalTo(@1);
            make.right.equalTo(_userOrderView.mas_right);
            make.top.equalTo(_userOrderView.mas_top).offset(fScreen(88));
        }];
        
        // 4个不同状态按钮
        NSString *titleString;
        CGFloat x = 0;
        CGFloat y = fScreen(88);
        CGFloat width = kAppWidth/4;
        CGFloat height = fScreen(200);
        __weak typeof(self) weakSelf = self;
        
        for (NSInteger index = 0; index < 4; index++) {
            switch (index) {
                case 0:
                    titleString = @"待付款";
                    break;
                case 1:
                    titleString = @"待发货";
                    break;
                case 2:
                    titleString = @"待收货";
                    break;
                case 3:
                    titleString = @"待评价";
                    break;
                default:
                    titleString = @"待付款";
                    break;
            }
            
            MineOrderButton *button = [[MineOrderButton alloc] initWithType:titleString];
            button.clickBlock = ^(NSString *title){
                [weakSelf orderButtonClick:title];
            };
            
            CGRect frame = CGRectMake(x, y, width, height);
            [button setFrame:frame];
            [_userOrderView addSubview:button];

            x += width;
        }
    }
    return _userOrderView;
}

- (UIView *)userInfoView
{
    if (!_userInfoView) {
        _userInfoView = [[UIView alloc] init];
        
        // 背景
        UIImageView *bgImageView = [[UIImageView alloc] init];
        [bgImageView setImage:[UIImage imageNamed:@"组-28@2x"]];
        [_userInfoView addSubview:bgImageView];
        
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(_userInfoView);
        }];
        
        // 头像
        self.userIconImageView = [[UIImageView alloc] init];
        [self.userIconImageView setClipsToBounds:YES];
        [self.userIconImageView.layer setCornerRadius:fScreen(120/2)];
        [self.userIconImageView.layer setBorderWidth:fScreen(3)];
        [self.userIconImageView.layer setBorderColor:HexColorA(0xffffff, 0.45).CGColor];
        
        [_userInfoView addSubview:self.userIconImageView];
        [self.userIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fScreen(120));
            make.height.mas_equalTo(fScreen(120));
            make.left.mas_equalTo(fScreen(42));
            make.top.mas_equalTo(fScreen(100));
        }];
        
        // 名称
        self.userNameLabel = [[UILabel alloc] init];
        [self.userNameLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [self.userNameLabel setTextColor:[UIColor whiteColor]];
        
        [_userInfoView addSubview:self.userNameLabel];
        [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userIconImageView.mas_right).offset(fScreen(20));
            make.right.equalTo(_userInfoView.mas_right);
            make.centerY.equalTo(self.userIconImageView.mas_centerY);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(32)];
            make.height.mas_equalTo(textSize.height);
        }];
        
        
        // 设置按钮
        UIButton *settingButton = [[UIButton alloc] init];
        [settingButton setImage:[UIImage imageNamed:@"icon-shezhi"] forState:UIControlStateNormal];
        [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userInfoView addSubview:settingButton];
        
        [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fScreen(44 + 28*2));
            make.height.mas_equalTo(fScreen(44 + 28*2));
            make.top.equalTo(_userInfoView.mas_top).offset(fScreen(54 - 28));
            make.right.equalTo(_userInfoView.mas_right);
        }];
        
        
        __weak typeof(self) weakSelf = self;
        
        // 收藏的商品
        self.collGoodsButton = [[MineUserInfoButton alloc] init];
        [self.collGoodsButton setNumber:[HDUserDefaults objectForKey:cUserCollectionGoodsNumber] buttonType:MineUserInfoButtonType_goods];
        self.collGoodsButton.clickBlock = ^(){
            [weakSelf collectionGoodsButtonClick];
        };
        
        [_userInfoView addSubview:self.collGoodsButton];
        [self.collGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_userInfoView);
            make.width.mas_equalTo(kAppWidth/2);
            make.height.mas_equalTo(fScreen(130));
        }];
        
        // 关注的店铺
        self.collStoreButton = [[MineUserInfoButton alloc] init];
        [self.collStoreButton setNumber:[HDUserDefaults objectForKey:cUserCollectionStoreNumber] buttonType:MineUserInfoButtonType_store];
        self.collStoreButton.clickBlock = ^(){
            [weakSelf collectionStoreButtonClick];
        };
        
        [_userInfoView addSubview:self.collStoreButton];
        [self.collStoreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(_userInfoView);
            make.width.height.equalTo(self.collGoodsButton);
        }];
        
        // 竖线
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor whiteColor]];
        [_userInfoView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fScreen(2));
            make.height.mas_equalTo(fScreen(88));
            make.centerX.equalTo(_userInfoView.mas_centerX);
            make.centerY.equalTo(self.collGoodsButton.mas_centerY);
        }];
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(iconButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_userInfoView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_userInfoView);
            make.bottom.equalTo(self.collGoodsButton.mas_top);
            make.top.equalTo(self.userIconImageView.mas_top);
        }];
    }
    return _userInfoView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



#pragma mark
#pragma mark - MineUserInfoButton
@interface MineUserInfoButton ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageIcon;

@end

@implementation MineUserInfoButton

- (instancetype)init
{
    if (self = [super init]) {
        // number
        self.numberLabel = [[UILabel alloc] init];
        [self.numberLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [self.numberLabel setTextColor:[UIColor whiteColor]];
        [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
        [self.numberLabel setText:@"0"];
        [self addSubview:self.numberLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(fScreen(29));
            make.left.right.equalTo(self);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(32)];
            make.height.mas_equalTo(textSize.height);
        }];
        
        CGSize textSize = [@"收藏的商品" sizeForFontsize:fScreen(24)];
        CGFloat iconWith = fScreen(30);
        CGFloat iconTextWidth = textSize.width + 2 + iconWith;
    
        
        // image
        self.imageIcon = [[UIImageView alloc] init];
        [self addSubview:self.imageIcon];
        
        [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fScreen(30));
            make.height.mas_equalTo(fScreen(30));
            make.left.equalTo(self.mas_left).offset((kAppWidth/2 - iconTextWidth)/2);
            make.bottom.equalTo(self.mas_bottom).offset(-fScreen(28));
        }];
        
        // title
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageIcon.mas_right).offset(fScreen(20));
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-fScreen(30));
            make.height.mas_equalTo(textSize.height);
        }];
        
        // button 覆盖
        UIButton *button = [[UIButton alloc] init];
        [button setBackgroundImage:[UIImage imageNamed:@"矩形-7"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setNumber:(NSString *)numberStr buttonType:(MineUserInfoButtonType)type
{
    [self.numberLabel setText:numberStr];
    if (type == MineUserInfoButtonType_goods) {
        [self.titleLabel setText:@"收藏的商品"];
        [self.imageIcon setImage:[UIImage imageNamed:@"icon_shoucang"]];
    }
    else if (type == MineUserInfoButtonType_store) {
        [self.titleLabel setText:@"关注的店铺"];
        [self.imageIcon setImage:[UIImage imageNamed:@"icon_guanzhu"]];
    }
}

- (void)setNumber:(NSString *)number
{
    [self.numberLabel setText:number];
}

@end


#pragma mark 
#pragma mark - MineOrderButton
@interface MineOrderButton ()

@property (nonatomic, copy) NSString *titleText;

@end

@implementation MineOrderButton

- (instancetype)initWithType:(NSString *)title
{
    if (self = [super init]) {
        
        self.titleText = title;
        
        UILabel *label = [[UILabel alloc] init];
        [label setText:title];
        [label setTextColor:HexColor(0x999999)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
        
        CGSize textSize = [title sizeForFontsize:fScreen(24)];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.mas_bottom).offset(-fScreen(45));
            make.width.mas_equalTo(textSize.width + 4);
            make.height.mas_equalTo(textSize.height);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(label.mas_top).offset(-fScreen(20));
            make.width.mas_equalTo(fScreen(68));
            make.height.mas_equalTo(fScreen(68));
        }];
        
        [imageView setImage:[UIImage imageNamed:title]];
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock(self.titleText);
    }
}

@end


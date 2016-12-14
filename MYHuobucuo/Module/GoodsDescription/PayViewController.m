//
//  PayViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/18.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "PayViewController.h"
#import <Masonry.h>

@interface PayViewController ()

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *payMoney;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *orderInfoView;
@property (nonatomic, strong) UIView *payStyleView;

@property (nonatomic, strong) UIButton *alipayButton;       // 支付宝支付
@property (nonatomic, strong) UIButton *wechatButton;       // 微信支付
@property (nonatomic, assign) PayStyle payStyle;            // 选择的支付方式

@end

@implementation PayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.payStyle = PayStyle_Default;

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithOrderNo:(NSString *)orderNo payMoney:(NSString *)payMoney
{
    if (self = [super init]) {
        self.orderNo = orderNo;
        self.payMoney = payMoney;
    }
    return self;
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"支付方式"];
    
    [self addOrderInfoView];
    
    [self addPayStyleView];
    
    UIButton *toPayButton = [[UIButton alloc] init];
    [toPayButton setBackgroundColor:RGB(228, 75, 98)];
    [toPayButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [toPayButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [toPayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toPayButton addTarget:self action:@selector(toPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toPayButton];
    [toPayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.payStyleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
}

- (void)addPayStyleView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.orderInfoView.mas_bottom).offset(fScreen(10));
        make.height.mas_equalTo(fScreen(200));
    }];
    self.payStyleView = view;
    
    UIView *alipayView = [self makePayCellWithTag:PayStyle_AliPay];
    UIView *wechatView = [self makePayCellWithTag:PayStyle_Wechat];
    
    [view addSubview:alipayView];
    [alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(view);
        make.bottom.equalTo(view.mas_centerY);
    }];
    
    [view addSubview:wechatView];
    [wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.top.equalTo(view.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(fScreen(28));
        make.height.equalTo(@1);
        make.right.equalTo(view).offset(-fScreen(28));
        make.centerY.equalTo(view.mas_centerY);
    }];
}

- (void)addOrderInfoView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(10));
        make.height.mas_equalTo(fScreen(134));
    }];
    self.orderInfoView = view;
    
    UILabel *orderNoLabel = [self makeLabel];
    [orderNoLabel setText:[NSString stringWithFormat:@"订单编号:  %@",self.orderNo]];
    [view addSubview:orderNoLabel];
    [orderNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(28));
        make.top.equalTo(view.mas_top).offset(fScreen(30));
        make.right.equalTo(view.mas_right).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(28));
    }];
    
    UILabel *payMoneyLabel = [self makeLabel];
    NSString *payString = [NSString stringWithFormat:@"应付金额:  ￥%@",self.payMoney];
    NSMutableAttributedString *attrPayString = [[NSMutableAttributedString alloc] initWithString:payString];
    [attrPayString addAttributes:@{NSForegroundColorAttributeName : HexColor(0xe44a62)} range:NSMakeRange(6, payString.length - 6)];
    [payMoneyLabel setAttributedText:attrPayString];
    
    [view addSubview:payMoneyLabel];
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(orderNoLabel);
        make.top.equalTo(orderNoLabel.mas_bottom).offset(fScreen(20));
    }];
}

- (UIView *)makePayCellWithTag:(NSInteger)tag
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [cellView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(28));
        make.centerY.equalTo(cellView.mas_centerY);
        make.width.mas_equalTo(fScreen(38));
        make.height.mas_equalTo(fScreen(38));
    }];
    
    UILabel *label = [self makeLabel];
    [cellView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(fScreen(10));
        make.top.bottom.equalTo(cellView);
        make.width.mas_equalTo(kAppWidth/2);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"icon_xuanze"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_xuanzhong"] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(payStyleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [cellView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(cellView);
        make.width.mas_equalTo(fScreen(100));
    }];
    
    
    if (tag == PayStyle_AliPay) {
        // 支付宝
        [label setText:@"支付宝支付"];
        [iconView setImage:[UIImage imageNamed:@"icon_zhifuabo"]];
        self.alipayButton = button;
    }
    else if (tag == PayStyle_Wechat) {
        // 微信
        [label setText:@"微信支付"];
        [iconView setImage:[UIImage imageNamed:@"icon_weiixn-"]];
        self.wechatButton = button;
    }
    
    return cellView;
}

- (UILabel *)makeLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [label setTextColor:HexColor(0x666666)];
    
    return label;
}

#pragma mark - button click
- (void)payStyleButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.tag == PayStyle_AliPay) {
        self.wechatButton.selected = NO;
        self.payStyle = PayStyle_AliPay;
    }
    else if (sender.tag == PayStyle_Wechat) {
        self.alipayButton.selected = NO;
        self.payStyle = PayStyle_Wechat;
    }
}

- (void)toPayButtonClick:(UIButton *)sender
{
    
}

- (void)backButtonClick:(UIButton *)sender
{
 
    [super backButtonClick:sender];
}

@end

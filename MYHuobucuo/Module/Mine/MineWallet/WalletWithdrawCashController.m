//
//  WalletWithdrawCashController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "WalletWithdrawCashController.h"
#import <Masonry.h>

@interface WalletWithdrawCashController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, copy) NSString *canWithdrawCash;          // 可提现现约
@property (nonatomic, assign) PayStyle cashStyle;               // 提现类型

@property (nonatomic, strong) UITextField *withDrawCashField;   // 提现金额
@property (nonatomic, strong) UIButton *alipayButton;
@property (nonatomic, strong) UIButton *wechatButton;

@end

@implementation WalletWithdrawCashController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    [self hideTabBar];
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
     self.canWithdrawCash = @"888.98";
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"我要提现"];
    
    UIView *cashView = [[UIView alloc] init];
    [cashView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:cashView];
    [cashView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88 * 2));
    }];
    
    
    UILabel *canCashTitleLabel = [self makeLabel];
    [canCashTitleLabel setText:@"可提现余额"];
    [cashView addSubview:canCashTitleLabel];
    [canCashTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cashView).offset(fScreen(30));
        make.top.equalTo(cashView).offset(fScreen(88 - 28)/2);
        make.width.mas_equalTo(kAppWidth/2);
        make.height.mas_equalTo(fScreen(28));
    }];
    
    UILabel *canCashLabel = [[UILabel alloc] init];
    [canCashLabel setTextColor:HexColor(0xe44a62)];
    [canCashLabel setTextAlignment:NSTextAlignmentRight];
    [canCashLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    NSMutableAttributedString *canCashString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥ %@", self.canWithdrawCash]];
    [canCashString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]} range:NSMakeRange(0, 1)];
    [canCashLabel setAttributedText:canCashString];
    [cashView addSubview:canCashLabel];
    [canCashLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cashView).offset(-fScreen(30));
        make.centerY.equalTo(canCashTitleLabel);
        make.height.mas_equalTo(fScreen(32));
        make.width.mas_equalTo(kAppWidth/2);
    }];
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:viewControllerBgColor];
    [cashView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(cashView);
        make.height.mas_equalTo(fScreen(2));
        make.top.equalTo(cashView).offset(fScreen(88));
    }];
    
    UILabel *withdrawTitleLabel = [self makeLabel];
    [withdrawTitleLabel setText:@"提现金额(元)"];
    [cashView addSubview:withdrawTitleLabel];
    [withdrawTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cashView).offset(fScreen(30));
        make.top.equalTo(line).offset(fScreen(88 - 28)/2);
        make.width.mas_equalTo(kAppWidth/2);
        make.height.mas_equalTo(fScreen(28));
    }];
    
    UITextField *cashField = [[UITextField alloc] init];
    [cashField setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [cashField setTextColor:HexColor(0xe44a62)];
    [cashField setTextAlignment:NSTextAlignmentRight];
    [cashField setPlaceholder:@"请输入提现金额"];
    [cashField setTintColor:HexColor(0xe44a62)];
    [cashField setKeyboardType:UIKeyboardTypeDecimalPad];
    [cashField setDelegate:self];
    [cashView addSubview:cashField];
    [cashField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(canCashLabel);
        make.height.mas_equalTo(fScreen(44));
        make.centerY.equalTo(withdrawTitleLabel);
    }];
    
    UIView *apliyView = [self makePayCellWithTag:PayStyle_AliPay];
    [self.view addSubview:apliyView];
    [apliyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(cashView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
    
    UIView *wechatView = [self makePayCellWithTag:PayStyle_Wechat];
    [self.view addSubview:wechatView];
    [wechatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(apliyView);
        make.top.equalTo(apliyView.mas_bottom).offset(1);
    }];
    
    NSString *infoString = @"* 提现金额必须为数字且不能大于可提现金额";
    NSMutableAttributedString *infoAttrString = [[NSMutableAttributedString alloc] initWithString:infoString];
    [infoAttrString addAttributes:@{NSForegroundColorAttributeName : HexColor(0xe44a62)} range:NSMakeRange(0, 1)];
    UILabel *infoLabel = [[UILabel alloc] init];
    [infoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [infoLabel setTextColor:HexColor(0x999999)];
    [infoLabel setAttributedText:infoAttrString];
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(fScreen(30));
        make.top.equalTo(wechatView.mas_bottom).offset(fScreen(20));
        make.right.equalTo(self.view).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    UIButton *toWithdrawCashButton = [[UIButton alloc] init];
    [toWithdrawCashButton.layer setCornerRadius:fScreen(8)];
    [toWithdrawCashButton setBackgroundColor:HexColor(0xe44a62)];
    [toWithdrawCashButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [toWithdrawCashButton setTitle:@"确认提现" forState:UIControlStateNormal];
    [toWithdrawCashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toWithdrawCashButton addTarget:self action:@selector(toWithdrawCashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:toWithdrawCashButton];
    [toWithdrawCashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(680));
        make.bottom.equalTo(self.view).offset(-fScreen(20));
        make.centerX.equalTo(self.view);
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
        [label setText:@"提现到支付宝"];
        [iconView setImage:[UIImage imageNamed:@"icon_zhifuabo"]];
        self.alipayButton = button;
    }
    else if (tag == PayStyle_Wechat) {
        // 微信
        [label setText:@"提现到微信钱包"];
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

#pragma mark - textField delegate
// 限制只能输入小数点后两位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag = 0;
    const NSInteger limited = 2;
    
    for (NSInteger i = futureString.length - 1; i >= 0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            break;
        }
        
        flag++;
    }
    
    return YES;
}

#pragma mark - button click
- (void)payStyleButtonClick:(UIButton *)sender
{
    self.cashStyle = sender.tag;
    sender.selected = YES;
    
    if (self.cashStyle == PayStyle_AliPay) {
        self.wechatButton.selected = NO;
    }
    else {
        self.alipayButton.selected = NO;
    }
}

- (void)toWithdrawCashButtonClick:(UIButton *)sender
{}
@end

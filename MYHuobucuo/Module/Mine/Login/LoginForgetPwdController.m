//
//  LoginForgetPwdController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/5.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "LoginForgetPwdController.h"
#import <Masonry.h>
#import "LoginForgetEditPwdController.h"

@interface LoginForgetPwdController ()

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UITextField *phoneField;      // 手机号码
@property (nonatomic, strong) UITextField *checkCodeField;  // 验证码
@property (nonatomic, strong) UIButton *getCodeButton;      // 获取验证码

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LoginForgetPwdController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"验证手机号"];
    
    UILabel *topInfoLabel = [[UILabel alloc] init];
    [topInfoLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [topInfoLabel setTextColor:HexColor(0x666666)];
    [topInfoLabel setText:@"为了你的账号安全, 请验证手机号码"];
    [self.view addSubview:topInfoLabel];
    [topInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(fScreen(36));
        make.top.equalTo(self.titleView.mas_bottom);
        make.height.mas_equalTo(fScreen(88));
        make.right.equalTo(self.view);
    }];
    
    // 手机号码
    UIView *phoneView = [self makeEidtCellViewWithTitle:@"手机号码"];
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(topInfoLabel.mas_bottom);
        make.height.mas_equalTo(fScreen(88));
    }];
    
    // 短信验证码
    UIView *checkCodeView = [self makeEidtCellViewWithTitle:@"短信验证码"];
    [self.view addSubview:checkCodeView];
    [checkCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88) - 1);
        make.top.equalTo(phoneView.mas_bottom);
    }];
    
    UIView *verLine = [[UIView alloc] init];
    [verLine setBackgroundColor:HexColor(0xdadada)];
    [self.view addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-fScreen(210));
        make.height.mas_equalTo(fScreen(40));
        make.width.mas_equalTo(fScreen(2));
        make.centerY.equalTo(checkCodeView);
    }];
    
    UIButton *getCodeButton = [[UIButton alloc] init];
    [getCodeButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [getCodeButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeButton addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [checkCodeView addSubview:getCodeButton];
    [getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verLine);
        make.top.bottom.right.equalTo(checkCodeView);
    }];
    self.getCodeButton = getCodeButton;
    
    // 底部说明
    UILabel *bottomInfoLabel = [[UILabel alloc] init];
    [bottomInfoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [bottomInfoLabel setTextColor:HexColor(0x999999)];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@" * 若长时间未收到验证短信, 请联系客服0595-28000105"];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : HexColor(0xe44a62)};
    [attrString addAttributes:attrDict range:NSMakeRange(0, 2)];
    [bottomInfoLabel setAttributedText:attrString];
    [self.view addSubview:bottomInfoLabel];
    [bottomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(fScreen(30));
        make.right.equalTo(self.view);
        make.top.equalTo(checkCodeView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    // 下一步
    UIButton *nextButton = [[UIButton alloc] init];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:HexColor(0xe44a62)];
    [nextButton.layer setCornerRadius:fScreen(8)];
    [nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottomInfoLabel.mas_bottom).offset(fScreen(40));
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(680));
    }];
}

- (UIView *)makeEidtCellViewWithTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [titleLabel setText:title];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(38));
        make.top.bottom.equalTo(view);
        CGSize textSize = [titleLabel.text sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width + 2);
    }];
    
    UITextField *txtField = [[UITextField alloc] init];
    [txtField setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [txtField setTextColor:HexColor(0x999999)];
    [txtField setTintColor:HexColor(0xe44a62)];
    [view addSubview:txtField];
    [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel.mas_right).offset(fScreen(30));
        make.top.bottom.equalTo(view);
        if ([title isEqualToString:@"手机号码"]) {
            make.right.equalTo(view).offset(-fScreen(30));
        }
        else {
            make.right.equalTo(view).offset(-fScreen(210) - fScreen(20));
        }
    }];
    
    if ([title isEqualToString:@"手机号码"]) {
        self. phoneField = txtField;
    }
    else if ([title isEqualToString:@"短信验证码"]) {
        self.checkCodeField = txtField;
        txtField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.right.bottom.equalTo(view);
        make.height.equalTo(@1);
    }];
    
    return view;
}

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNumber];
}

#pragma mark - button click
- (void)getCodeButtonClick:(UIButton *)sender
{
    [sender setEnabled:NO];
    
    if (![self checkPhoneNumber:self.phoneField.text]) {
        [MYProgressHUD showAlertWithMessage:@"手机号码格式不对,请检查"];
        [sender setEnabled:YES];
        return;
    }
    
    [MYProgressHUD showAlertWithMessage:@"短信已发送,请注意查收"];
    
    if (!self.timer) {
        static NSInteger time = 60;
        __weak typeof(self) weakSelf = self;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f repeats:YES block:^(NSTimer * _Nonnull timer) {
            time--;
            if (time == 0) {
                [weakSelf.timer invalidate];
                weakSelf.timer = nil;
                
                [weakSelf.getCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                [weakSelf.getCodeButton setEnabled:YES];
                time = 60;
                return ;
            }
            [weakSelf.getCodeButton setTitle:[NSString stringWithFormat:@"%lds",time] forState:UIControlStateNormal];
        }];
        return;
    }
}

- (void)nextButtonClick:(UIButton *)sender
{
    // 校验
    if (self.checkCodeField.text.length == 0) {
        [MYProgressHUD showAlertWithMessage:@"验证码不能为空!"];
        return;
    }
    
    LoginForgetEditPwdController *editPwdVC = [[LoginForgetEditPwdController alloc] init];
    [self.navigationController pushViewController:editPwdVC animated:YES];
}

@end

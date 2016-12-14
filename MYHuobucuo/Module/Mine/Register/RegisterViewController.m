//
//  RegisterViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/9/30.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "RegisterViewController.h"

#import <Masonry.h>
#import "NetworkRequest.h"
#import "HDDeviceInfo.h"

@interface RegisterViewController ()

@property (nonatomic, strong) UITextField *phoneField;      // 手机号
@property (nonatomic, strong) UITextField *checkCodeField;  // 验证码
@property (nonatomic, strong) UITextField *passwordField;   // 密码
@property (nonatomic, strong) UIButton *checkCodeButton;    // 获取验证码按钮
@property (nonatomic, strong) UIButton *registerButton;     // 注册按钮
@property (nonatomic, strong) UIButton *agreeButton;        // 同意协议按钮

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation RegisterViewController

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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bj_img"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
    UIButton *backButton = [self makeBackButton];
    [self.view addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view).offset(20);
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(28*2 + 38));
    }];
    
    // 千县农汇
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_qianxian"]];
    [self.view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(fScreen(240));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(fScreen(200), fScreen(200)));
    }];
    
    // 手机号
    UIView *phoneLineView = [[UIView alloc] init];
    [phoneLineView setBackgroundColor:HexColor(0xdadada)];
    [self.view addSubview:phoneLineView];
    [phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(fScreen(468));
        make.top.equalTo(iconView.mas_bottom).offset(fScreen(200));
    }];
    
    UITextField *phoneField = [self createTextField];
    [phoneField setPlaceholder:@"请输入手机号码"];
    [self.view addSubview:phoneField];
    [phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneLineView).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(38));
        make.right.equalTo(phoneLineView).offset(-fScreen(20));
        make.bottom.equalTo(phoneLineView.mas_top).offset(-fScreen(10));
    }];
    self.phoneField = phoneField;
    [phoneField becomeFirstResponder];
    
    // 验证码
    UIView *checkCodeLine = [[UIView alloc] init];
    [checkCodeLine setBackgroundColor:phoneLineView.backgroundColor];
    [self.view addSubview:checkCodeLine];
    [checkCodeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.width.centerX.equalTo(phoneLineView);
        make.top.equalTo(phoneLineView.mas_bottom).offset(fScreen(116));
    }];
    
    UIView *verLine = [[UIView alloc] init];
    [verLine setBackgroundColor:phoneLineView.backgroundColor];
    [self.view addSubview:verLine];
    [verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-fScreen(300));
        make.height.mas_equalTo(fScreen(40));
        make.width.mas_equalTo(fScreen(2));
        make.bottom.equalTo(checkCodeLine.mas_top).offset(-fScreen(20));
    }];
    
    UITextField *checkCodeField = [self createTextField];
    [checkCodeField setPlaceholder:@"请输入验证码"];
    [self.view addSubview:checkCodeField];
    [checkCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkCodeLine).offset(fScreen(30));
        make.height.mas_equalTo(fScreen(38));
        make.bottom.equalTo(checkCodeLine.mas_top).offset(-fScreen(20));
        make.right.equalTo(verLine.mas_left).offset(-fScreen(30));
    }];
    self.checkCodeField = checkCodeField;
    
    UIButton *getCodeButton = [[UIButton alloc] init];
    [getCodeButton setContentMode:UIViewContentModeLeft];
    [getCodeButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [getCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getCodeButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [getCodeButton addTarget:self action:@selector(getCodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCodeButton];
    [getCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verLine.mas_right).offset(fScreen(20));
        make.height.bottom.equalTo(verLine);
        make.right.equalTo(checkCodeLine);
    }];
    self.checkCodeButton = getCodeButton;
    
    // 密码
    UIView *pwdLine = [[UIView alloc] init];
    [pwdLine setBackgroundColor:phoneLineView.backgroundColor];
    [self.view addSubview:pwdLine];
    [pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.centerX.equalTo(checkCodeLine);
        make.top.equalTo(checkCodeLine.mas_bottom).offset(fScreen(116));
    }];
    
    UITextField *pwdField = [self createTextField];
    [pwdField setSecureTextEntry:YES];
    [pwdField setPlaceholder:@"请设置登录密码"];
    [self.view addSubview:pwdField];
    [pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(checkCodeLine).offset(fScreen(30));
        make.height.mas_equalTo(fScreen(38));
        make.bottom.equalTo(pwdLine.mas_top).offset(-fScreen(20));
        make.right.equalTo(pwdLine).offset(-fScreen(30));
    }];
    self.passwordField = pwdField;
    
    // 协议
    UIButton *agreeButton = [[UIButton alloc] init];
    [agreeButton setImage:[UIImage imageNamed:@"icon_f"] forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"icon_n"] forState:UIControlStateSelected];
    [agreeButton setSelected:YES];
    [agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeButton];
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(fScreen(48));
        make.width.mas_equalTo(fScreen(48));
        make.top.equalTo(pwdLine.mas_bottom).offset(fScreen(40 - 10));
        make.left.equalTo(pwdLine).offset(-fScreen(10));
    }];
    self.agreeButton = agreeButton;
    
    UILabel *protocolLabel = [[UILabel alloc] init];
    [protocolLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [protocolLabel setTextColor:HexColor(0x999999)];
    [self.view addSubview:protocolLabel];
    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(agreeButton.mas_right).offset(fScreen(20));
        make.centerY.equalTo(agreeButton);
        make.height.mas_equalTo(fScreen(26));
        make.width.mas_equalTo(fScreen(370));
    }];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"同意 千县农汇用户服务协议"];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : HexColor(0x5560f1), NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName:  HexColor(0x5560f1)};
    [attrString addAttributes:attrDict range:NSMakeRange(3, attrString.length - 3)];
    [protocolLabel setAttributedText:attrString];
    
    UIButton *protoclButton = [[UIButton alloc] init];
    [protoclButton addTarget:self action:@selector(readProtocol) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:protoclButton];
    [protoclButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(protocolLabel).offset(-fScreen(10));
        make.bottom.equalTo(protocolLabel).offset(fScreen(10));
        make.left.equalTo(protocolLabel).offset(fScreen(50));
        make.right.equalTo(protocolLabel);
    }];
    
    // 去登录
    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [loginButton setTitle:@"已有账号去登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(toLoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-fScreen(68 - 10));
        make.height.mas_equalTo(fScreen(26 + 10*2));
        make.left.right.equalTo(self.view);
    }];
    
    // 注册
    UIButton *registerButton = [[UIButton alloc] init];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [registerButton setBackgroundColor:[UIColor whiteColor]];
    [registerButton.layer setCornerRadius:fScreen(44)];
    [registerButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(loginButton.mas_top).offset(-fScreen(76 - 10));
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(520));
        make.centerX.equalTo(self.view);
    }];
}


- (UITextField *)createTextField
{
    UITextField *textField = [[UITextField alloc] init];
    [textField setTintColor:HexColor(0xe44a62)];
    [textField setFont:[UIFont systemFontOfSize:fScreen(26)]];
    
    return textField;
}

#pragma mark - button click

- (void)toLoginButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)agreeButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    
}

// 阅读协议
- (void)readProtocol
{

}

// 获取验证码
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
                [weakSelf.checkCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                [weakSelf.checkCodeButton setEnabled:YES];
                return ;
            }
            [weakSelf.checkCodeButton setTitle:[NSString stringWithFormat:@"%lds",time] forState:UIControlStateNormal];
        }];
    }
}

- (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:phoneNumber];
}

- (void)registerButtonClick:(UIButton *)sender
{
    // 校验
    if (self.checkCodeField.text.length == 0) {
        [MYProgressHUD showAlertWithMessage:@"验证码不能为空!"];
        return;
    }
    
    if (self.passwordField.text.length == 0) {
        [MYProgressHUD showAlertWithMessage:@"密码不能为空!"];
        return;
    }
    else if (self.passwordField.text.length < 6) {
        [MYProgressHUD showAlertWithMessage:@"密码不能低于6个字符!"];
        return;
    }
    else if (self.passwordField.text.length > 20) {
        [MYProgressHUD showAlertWithMessage:@"密码不能超过20个字符!"];
        return;
    }
        
    
    if (!self.agreeButton.selected) {
        [MYProgressHUD showAlertWithMessage:@"需要同意千县农汇用户服务协议才能注册哦~"];
        return;
    }
    
    // 注册
    [[NetworkRequest sharedNetworkRequest] userRegisterWithUserName:self.phoneField.text password:self.passwordField.text checkCode:self.checkCodeField.text finishBlock:^(id jsonData, NSError *error) {
        
    }];
}

@end

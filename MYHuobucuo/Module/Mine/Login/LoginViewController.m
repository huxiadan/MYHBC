//
//  LoginViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/9/30.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "LoginViewController.h"

#import <Masonry.h>
#import "NetworkRequest.h"
#import "RegisterViewController.h"
#import "LoginForgetPwdController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UITextField *userNameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *unionId;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    [self hideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
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
    
    // 用户名
        
    UIView *userNameLine = [[UIView alloc] init];
    [userNameLine setBackgroundColor:HexColor(0xdadada)];
    [self.view addSubview:userNameLine];
    [userNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(fScreen(468));
        make.top.equalTo(iconView.mas_bottom).offset(fScreen(224));
    }];
    
    UIImageView *userNameIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-_wo"]];
    [self.view addSubview:userNameIcon];
    [userNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLine.mas_left).offset(fScreen(12));
        make.height.mas_equalTo(fScreen(38));
        make.width.mas_equalTo(fScreen(30));
        make.bottom.equalTo(userNameLine.mas_top).offset(-fScreen(20));
    }];
    
    UITextField *userNameField = [self createTextField];
    [userNameField setPlaceholder:@"用户名/手机号码"];
    [userNameField setTintColor:HexColor(0xe44a62)];
    [userNameField becomeFirstResponder];
    self.userNameField = userNameField;
    [self.view addSubview:self.userNameField];
    
    [userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameIcon.mas_right).offset(fScreen(28));
        make.right.equalTo(userNameLine.mas_right).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(36));
        make.centerY.equalTo(userNameIcon);
    }];
    
    
    // 密码
    
    UIView *passworddLine = [[UIView alloc] init];
    [passworddLine setBackgroundColor:HexColor(0xdadada)];
    [self.view addSubview:passworddLine];
    [passworddLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.height.width.equalTo(userNameLine);
        make.top.equalTo(userNameLine.mas_bottom).offset(fScreen(116));
    }];
    
    UIImageView *passwordIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_key"]];
    [self.view addSubview:passwordIcon];
    [passwordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(userNameIcon);
        make.bottom.equalTo(passworddLine.mas_top).offset(-fScreen(20));
    }];
    
    UITextField *passwordField = [self createTextField];
    passwordField.secureTextEntry = YES;
    [passwordField setPlaceholder:@"密码"];
    self.passwordField = passwordField;
    [self.view addSubview:self.passwordField];
    
    [passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(userNameField);
        make.centerY.equalTo(passwordIcon);
    }];
    
    // 忘记密码
    UIButton *forgetButton = [[UIButton alloc] init];
    [forgetButton setContentMode:UIViewContentModeLeft];
    [forgetButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetButton];
    [forgetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passworddLine);
        make.height.mas_equalTo(fScreen(24 + 20));
        make.width.mas_equalTo(fScreen(100));
        make.top.equalTo(passworddLine.mas_bottom).offset(fScreen(58 - 10));
    }];
    
    
    // 快速注册
    UIButton *fastRegButton = [[UIButton alloc] init];
    [fastRegButton setContentMode:UIViewContentModeRight];
    [fastRegButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [fastRegButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [fastRegButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [fastRegButton addTarget:self action:@selector(registerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fastRegButton];
    [fastRegButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(passworddLine);
        make.height.mas_equalTo(fScreen(24 + 20));
        make.width.mas_equalTo(fScreen(100));
        make.top.equalTo(passworddLine.mas_bottom).offset(fScreen(58 - 10));
    }];
    
    
    // 微信登录
    UIButton *wechatLoginButton = [[UIButton alloc] init];
    [wechatLoginButton setImage:[UIImage imageNamed:@"icon_wei_n"] forState:UIControlStateNormal];
    [wechatLoginButton setImage:[UIImage imageNamed:@"icon_wei_h"] forState:UIControlStateHighlighted];
    [wechatLoginButton addTarget:self action:@selector(wechatLoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:wechatLoginButton];
    [wechatLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-fScreen(100));
        make.left.equalTo(self.view).offset(fScreen(208));
        make.size.mas_equalTo(CGSizeMake(fScreen(68), fScreen(68)));
    }];

    // QQ 登录
    UIButton *qqLoginButton = [[UIButton alloc] init];
    [qqLoginButton setImage:[UIImage imageNamed:@"icon_QQ_n"] forState:UIControlStateNormal];
    [qqLoginButton setImage:[UIImage imageNamed:@"icon_QQ_h"] forState:UIControlStateHighlighted];
    [qqLoginButton addTarget:self action:@selector(qqLoginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLoginButton];
    [qqLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-fScreen(208));
        make.size.bottom.equalTo(wechatLoginButton);
    }];
    
    // 登录按钮

    UIButton *loginButton = [[UIButton alloc] init];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor whiteColor]];
    [loginButton.layer setCornerRadius:fScreen(44)];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton = loginButton;
    [self.view addSubview:self.loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(wechatLoginButton.mas_top).offset(-fScreen(112));
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(520));
        make.centerX.equalTo(self.view);
    }];
}

- (UITextField *)createTextField
{
    UITextField *textField = [[UITextField alloc] init];
    [textField setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [textField setTextColor:HexColor(0x333333)];
    
    return textField;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - button click
// 忘记密码
- (void)forgetButtonClick:(UIButton *)sender
{
    LoginForgetPwdController *forgetVC = [[LoginForgetPwdController alloc] init];
    [self.navigationController pushViewController:forgetVC animated:YES];
}

- (void)wechatLoginButtonClick:(UIButton *)sender
{}

- (void)qqLoginButtonClick:(UIButton *)sender
{}

// 登录
- (void)loginButtonClick:(UIButton *)sender
{
    // 检验
    if (self.userNameField.text.length == 0 || self.passwordField.text.length == 0 ) {
        [MYProgressHUD showAlertWithMessage:@"用户名/密码不能为空"];
        return;
    }
    
    // 登录动作
    if (self.openId == nil) {
        self.openId = @"";
    }
    if (self.unionId == nil) {
        self.unionId = @"";
    }
    
    __weak typeof(self) weakSekf = self;
    [[NetworkRequest sharedNetworkRequest] userLoginWithUserName:self.userNameField.text password:self.passwordField.text openId:self.openId unionId:self.unionId finishBlock:^(id jsonData, NSError *error) {
        if (error) {
            DLog(@"%@", error.localizedDescription);
        }
        else {
            if (jsonData) {
                NSDictionary *jsonDict = (NSDictionary *)jsonData;
                NSDictionary *statusDict = jsonDict[@"status"];
                if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                    [MYProgressHUD showAlertWithMessage:[NSString stringWithFormat:@"%@", statusDict[@"msg"]]];
                    return ;
                }
                else {
                    NSDictionary *dataDict = jsonData[@"data"];
                    
                    [AppUserManager userLogin];
                    [AppUserManager.user setValueWithDict:dataDict];
                    [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNoti object:nil];
                    
                    [MYProgressHUD showAlertWithMessage:@"登录成功~"];
                    
                    [weakSekf.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }
    }];
}

// 跳转注册
- (void)registerButtonClick:(UIButton *)sender
{
    RegisterViewController *registerController = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerController animated:YES];
}


@end

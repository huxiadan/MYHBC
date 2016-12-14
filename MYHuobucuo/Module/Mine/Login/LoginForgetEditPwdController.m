//
//  LoginForgetEditPwdController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/5.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "LoginForgetEditPwdController.h"
#import <Masonry.h>

@interface LoginForgetEditPwdController ()

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UITextField *pwdField;     // 新密码
@property (nonatomic, strong) UITextField *repeatPwdField;  // 重复新密码

@end

@implementation LoginForgetEditPwdController

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
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"忘记密码"];
    
    UIView *pwdView = [self makeEidtCellViewWithTitle:@"新密码" placeholder:@"请输入新密码"];
    [self.view addSubview:pwdView];
    [pwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
    
    UIView *repeatView = [self makeEidtCellViewWithTitle:@"重复新密码" placeholder:@"请确认新密码"];
    [self.view addSubview:repeatView];
    [repeatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(pwdView);
        make.height.mas_equalTo(fScreen(88) - 1);
        make.top.equalTo(pwdView.mas_bottom);
    }];
    
    // 底部说明
    UILabel *bottomInfoLabel = [[UILabel alloc] init];
    [bottomInfoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [bottomInfoLabel setTextColor:HexColor(0x999999)];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@" * 新密码由6-20位英文字母,数组火符号组成"];
    NSDictionary *attrDict = @{NSForegroundColorAttributeName : HexColor(0xe44a62)};
    [attrString addAttributes:attrDict range:NSMakeRange(0, 2)];
    [bottomInfoLabel setAttributedText:attrString];
    [self.view addSubview:bottomInfoLabel];
    [bottomInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(fScreen(30));
        make.right.equalTo(self.view);
        make.top.equalTo(repeatView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    // 确认修改
    UIButton *editPwdButton = [[UIButton alloc] init];
    [editPwdButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [editPwdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editPwdButton setBackgroundColor:HexColor(0xe44a62)];
    [editPwdButton.layer setCornerRadius:fScreen(8)];
    [editPwdButton addTarget:self action:@selector(editPwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editPwdButton];
    [editPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(bottomInfoLabel.mas_bottom).offset(fScreen(40));
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(680));
    }];
}

- (UIView *)makeEidtCellViewWithTitle:(NSString *)title placeholder:(NSString *)placeHolder
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
    [txtField setPlaceholder:placeHolder];
    [txtField setSecureTextEntry:YES];
    [txtField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [view addSubview:txtField];
    [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([title isEqualToString:@"重复新密码"]) {
            make.left.equalTo(titleLabel.mas_right).offset(fScreen(26));
        }
        else {
            make.left.equalTo(titleLabel.mas_right).offset(fScreen(60));
        }
        make.top.bottom.equalTo(view);
        make.right.equalTo(view.mas_right).offset(-fScreen(30));
    }];
    
    if ([title isEqualToString:@"新密码"]) {
        self.pwdField = txtField;
    }
    else if ([title isEqualToString:@"重复新密码"]) {
        self.repeatPwdField = txtField;
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


#pragma mark - button click
- (void)editPwdButtonClick:(UIButton *)sender
{
    if (![self.pwdField.text isEqualToString:self.repeatPwdField.text]) {
        [MYProgressHUD showAlertWithMessage:@"两次输入的密码不一致,请重新输入"];
        self.repeatPwdField.text = @"";
        [self.repeatPwdField becomeFirstResponder];
        return;
    }
    
    [MYProgressHUD showAlertWithMessage:@"修改密码成功!"];
}


@end

//
//  ChangePwdController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/4.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ChangePwdController.h"
#import <Masonry.h>
#import "MYProgressHUD.h"

@interface ChangePwdController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *editPwdView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIButton *makesureButton;

@property (nonatomic, strong) UITextField *PwdField;
@property (nonatomic, strong) UITextField *oldPwdField;
@property (nonatomic, strong) UITextField *repeatField;

@end

@implementation ChangePwdController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"修改密码"];
    
    [self addEditPwdView];
    
    [self addTipsLabel];
    
    [self addMakesureButton];
}

- (void)addEditPwdView
{
    UIView *editView = [[UIView alloc] init];
    [editView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:editView];
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88*3 - 1));
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
    }];
    self.editPwdView = editView;
    
    UIView *oldPwdView = [self makeEidtCellViewWithTitle:@"旧密码" placeholder:@"请输入旧密码"];
    UIView *newPwdView = [self makeEidtCellViewWithTitle:@"新密码" placeholder:@"请输入新密码"];
    UIView *repeatView = [self makeEidtCellViewWithTitle:@"重复新密码" placeholder:@"请确认新密码"];
    
    CGFloat width = kAppWidth;
    CGFloat height = fScreen(88);
    [oldPwdView setFrame:CGRectMake(0, 0, width, height)];
    [newPwdView setFrame:CGRectMake(0, height, width, height)];
    [repeatView setFrame:CGRectMake(0, 2*height, width, height)];
    
    [editView addSubview:oldPwdView];
    [editView addSubview:newPwdView];
    [editView addSubview:repeatView];
}

- (void)addTipsLabel
{
    UILabel *tips = [[UILabel alloc] init];
    [tips setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [tips setTextColor:HexColor(0x999999)];
    
    NSString *text = @"* 新密码由6-20位英文字母、数字或符号组成";
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    NSDictionary *attr = @{NSForegroundColorAttributeName : HexColor(0xff5f5f)};
    [attrText addAttributes:attr range:NSMakeRange(0, 1)];
    [tips setAttributedText:attrText];
    
    [self.view addSubview:tips];
    [tips mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(fScreen(30));
        make.top.equalTo(self.editPwdView.mas_bottom).offset(fScreen(20));
        make.right.equalTo(self.view.mas_right).offset(-fScreen(30));
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.tipsLabel = tips;
}

- (void)addMakesureButton
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"button_d"] forState:UIControlStateNormal];
    [button setUserInteractionEnabled:NO];
    [button addTarget:self action:@selector(makesureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(fScreen(40));
        make.width.mas_equalTo(fScreen(680));
        make.height.mas_equalTo(fScreen(88));
    }];
    self.makesureButton = button;
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
    [txtField setDelegate:self];
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
    
    if ([title isEqualToString:@"旧密码"]) {
        self.oldPwdField = txtField;
    }
    else if ([title isEqualToString:@"新密码"]) {
        self.PwdField = txtField;
    }
    else if ([title isEqualToString:@"重复新密码"]) {
        self.repeatField = txtField;
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

- (void)makesureButtonClick:(UIButton *)sender
{
    [self.oldPwdField resignFirstResponder];
    [self.PwdField resignFirstResponder];
    [self.repeatField resignFirstResponder];
    
    NSString *alertText;
    
    if ([self.oldPwdField.text isEqualToString:self.PwdField.text]) {
        alertText = @"新密码不能与旧密码相同!";
        [self.PwdField becomeFirstResponder];
    }
    else if (self.PwdField.text.length < 6 || self.PwdField.text.length > 20) {
        alertText = @"密码由6-20位英文字母、数字或符号组成";
        [self.PwdField becomeFirstResponder];
    }
    else if (![self.PwdField.text isEqualToString:self.repeatField.text]) {
        alertText = @"两次输入的新密码不一致!";
        [self.repeatField becomeFirstResponder];
    }
    else {
        // 修改密码
        [self toChangePassword];
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:alertText delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil, nil];
    [alert show];
    
}

- (void)toChangePassword
{
    if (YES) {
        [MYProgressHUD showAlertWithMessage:@"密码修改成功!"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

#pragma mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.PwdField.text.length != 0 &&
        self.oldPwdField.text.length != 0 &&
        self.repeatField.text.length != 0) {
        [self.makesureButton setImage:[UIImage imageNamed:@"button_n"] forState:UIControlStateNormal];
        [self.makesureButton setUserInteractionEnabled:YES];
    }
    else {
        [self.makesureButton setImage:[UIImage imageNamed:@"button_d"] forState:UIControlStateNormal];
        [self.makesureButton setUserInteractionEnabled:NO];
    }
    
    if (textField.text.length == 1 && [string isEqualToString:@""]) {
        [self.makesureButton setImage:[UIImage imageNamed:@"button_d"] forState:UIControlStateNormal];
        [self.makesureButton setUserInteractionEnabled:NO];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.PwdField.text.length != 0 &&
        self.oldPwdField.text.length != 0 &&
        self.repeatField.text.length != 0) {
        [self.makesureButton setImage:[UIImage imageNamed:@"button_n"] forState:UIControlStateNormal];
        [self.makesureButton setUserInteractionEnabled:YES];
    }
    else {
        [self.makesureButton setImage:[UIImage imageNamed:@"button_d"] forState:UIControlStateNormal];
        [self.makesureButton setUserInteractionEnabled:NO];
    }
}

@end

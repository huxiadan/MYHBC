//
//  EditUserNameController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/3.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "EditUserNameController.h"
#import <Masonry.h>

@interface EditUserNameController ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITextField *nameField;

@end

@implementation EditUserNameController

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
    
    [self addTitleView];
    
    [self addNameView];
}

- (void)addTitleView
{
    self.titleView = [self addTitleViewWithTitle:@"修改昵称"];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [saveButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_top).offset(20);
        make.right.bottom.equalTo(self.titleView);
        CGSize textSize = [saveButton.titleLabel.text sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(fScreen(30*2 + textSize.width + 4));
    }];
}

- (void)addNameView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88));
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
    }];
    
    UITextField *nameField = [[UITextField alloc] init];
    [nameField setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameField setTextColor:HexColor(0x666666)];
    [nameField setTintColor:HexColor(0xe44a62)];
    
    NSString *userName = [NSString stringWithFormat:@"%@",[HDUserDefaults objectForKey:cUserName] == nil ? @"" : [HDUserDefaults objectForKey:cUserName]];
    [nameField setText:userName];
    
    [view addSubview:nameField];
    [nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.top.right.bottom.equalTo(view);
    }];
    self.nameField = nameField;
}

- (void)saveButtonClick:(UIButton *)sender
{
    [HDUserDefaults setObject:self.nameField.text forKey:cUserName];
    [HDUserDefaults synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end

//
//  AccountSettingController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/3.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AccountSettingController.h"
#import <Masonry.h>
#import "ChangePwdController.h"

@interface AccountSettingController ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *thirdView;    // 第三方绑定的 view

@end

@implementation AccountSettingController

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
    
    self.titleView = [self addTitleViewWithTitle:@"账户设置"];
    
    [self addThirdView];
    
    [self addChangePwdView];
}

- (void)addThirdView
{
    UIView *thirdView = [[UIView alloc] init];
    [thirdView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:thirdView];
    [thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88*3) - 1);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
    }];
    self.thirdView = thirdView;
    
    UIView *phoneView = [self makeOptionViewWithTitle:@"手机" icon:[UIImage imageNamed:@"icon_phone"] subTitle:@"12222222222"];
    
    UIView *wechatView = [self makeOptionViewWithTitle:@"微信" icon:[UIImage imageNamed:@"icon--wei"] subTitle:[HDUserDefaults objectForKey:cUserWechat] == nil ? @"马上绑定": [HDUserDefaults objectForKey:cUserWechat]];
    
    UIView *qqView = [self makeOptionViewWithTitle:@"QQ" icon:[UIImage imageNamed:@"icon_qq"] subTitle:[HDUserDefaults objectForKey:cUserQQ] == nil ? @"马上绑定": [HDUserDefaults objectForKey:cUserQQ]];
    
    CGFloat width = kAppWidth;
    CGFloat height = fScreen(88);
    [phoneView setFrame:CGRectMake(0, 0, width, height)];
    [wechatView setFrame:CGRectMake(0, height, width, height)];
    [qqView setFrame:CGRectMake(0, 2*height, width, height)];
    
    [thirdView addSubview:phoneView];
    [thirdView addSubview:wechatView];
    [thirdView addSubview:qqView];
}

- (void)addChangePwdView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88));
        make.top.equalTo(self.thirdView.mas_bottom).offset(fScreen(20));
    }];
    
    UIImageView *arrow = [[UIImageView alloc] init];
    [arrow setImage:[UIImage imageNamed:@"icon_more"]];
    [view addSubview:arrow];
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-fScreen(30));
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(fScreen(14));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"修改密码"];
    [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [label setTextColor:HexColor(0x666666)];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.top.bottom.equalTo(view);
        make.right.equalTo(arrow.mas_left).offset(-fScreen(20));
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(changePwdButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(view);
    }];
}

- (UIView *)makeOptionViewWithTitle:(NSString *)title icon:(UIImage *)icon subTitle:(NSString *)subTitle
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    
 
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:icon];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(fScreen(38));
        make.height.mas_equalTo(fScreen(38));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(fScreen(20));
        make.top.bottom.equalTo(view);
        make.width.mas_equalTo(fScreen(200));
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] init];
    [arrowView setImage:[UIImage imageNamed:@"icon_more"]];
    [view addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).offset(-fScreen(30));
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(fScreen(14));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    [subTitleLabel setText:subTitle];
    [subTitleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [subTitleLabel setTextColor:HexColor(0x999999)];
    [subTitleLabel setTextAlignment:NSTextAlignmentRight];
    [view addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowView.mas_left).offset(-fScreen(20));
        make.top.bottom.equalTo(view);
        make.left.equalTo(titleLabel.mas_right);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(view);
        make.height.equalTo(@1);
    }];
    
    return view;
}

#pragma mark - button Click
- (void)changePwdButtonClick:(UIButton *)sender
{
    ChangePwdController *pwdController = [[ChangePwdController alloc] init];
    [self.navigationController pushViewController:pwdController animated:YES];
}

@end

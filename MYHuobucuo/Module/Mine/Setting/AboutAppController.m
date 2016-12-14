//
//  AboutAppController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/3.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AboutAppController.h"
#import <Masonry.h>

@interface AboutAppController ()

@property (nonatomic, strong) UIView *titleView;

@end

@implementation AboutAppController

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
    
    self.titleView = [self addTitleViewWithTitle:@"关于"];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [iconImageView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(88));
        make.width.mas_equalTo(fScreen(300));
        make.height.mas_equalTo(fScreen(300));
    }];
    
    UITextField *adviceField = [[UITextField alloc] init];
    adviceField.userInteractionEnabled = NO;
    [adviceField setBackgroundColor:[UIColor whiteColor]];
    [adviceField setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [adviceField setTextColor:HexColor(0x666666)];
    UIView *leftView = [[UIView alloc] init];
    [leftView setFrame:CGRectMake(0, 0, fScreen(30), 100)];
    adviceField.leftView = leftView;
    adviceField.leftViewMode = UITextFieldViewModeAlways;
    adviceField.text = @"给我评价";
    [self.view addSubview:adviceField];
    [adviceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(iconImageView.mas_bottom).offset(fScreen(168));
        make.height.mas_equalTo(fScreen(88));
    }];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    [infoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [infoLabel setText:@"2016 All Rights Reserved."];
    [infoLabel setTextColor:HexColor(0x999999)];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-fScreen(40));
        make.left.right.equalTo(self.view);
        CGSize textSize = [infoLabel.text sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
    }];
    
    UILabel *versionLabel = [[UILabel alloc] init];
    [versionLabel setText:[NSString stringWithFormat:@"当前版本: %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]];
    [versionLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [versionLabel setTextColor:HexColor(0x666666)];
    [versionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(infoLabel.mas_top).offset(-fScreen(20));
        CGSize textSize = [versionLabel.text sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
    }];
}

- (void)addTitleView
{
    
}

@end

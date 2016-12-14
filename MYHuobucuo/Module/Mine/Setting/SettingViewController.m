//
//  SettingViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "SettingViewController.h"
#import <Masonry.h>
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "AboutAppController.h"
#import "AccountSettingController.h"
#import "FeedBackController.h"
#import "APNSSettingController.h"
#import <SDImageCache.h>

#define kOptionButtonTag 1024

@interface SettingViewController ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *optionView;   // 选项视图
@property (nonatomic, strong) UIView *cleanButton;

@property (nonatomic, strong) UIView *actionSheetCover;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self addTitleView];
    
    [self addOptionView];
    
    [self addClaenButton];
    
    [self addLoginOutButton];
}

- (void)addClaenButton
{
    UIView *cleanButton = [self makeOptionCellWithTitle:@"清除缓存" tag:kOptionButtonTag + 100  hasArrow:NO];
    [self.view addSubview:cleanButton];
    [cleanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.optionView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
    self.cleanButton = cleanButton;
}

- (void)addLoginOutButton
{
    UIButton *loginOutButton = [[UIButton alloc] init];
//    if ([HDUserDefaults objectForKey:cUserid] != nil) {
        // 登录
        [loginOutButton setImage:[UIImage imageNamed:@"button_exit"] forState:UIControlStateNormal];
//    }
//    else {
//        
//    }
    [loginOutButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutButton];
    [loginOutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cleanButton.mas_bottom).offset(fScreen(40));
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(fScreen(680));
        make.height.mas_equalTo(fScreen(88));
    }];
}

- (void)addTitleView
{
    self.titleView = [self addTitleViewWithTitle:@"设置"];
}

- (void)addOptionView
{
    UIView *optionView = [[UIView alloc] init];
    [optionView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:optionView];
    [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88*5) - 1);
    }];
    self.optionView = optionView;
    
    NSArray *optionTitles = @[@"个人资料", @"账户设置", @"消息推送", @"用户反馈", @"关于"];
    
    CGFloat y = 0;
    for (NSInteger index =0; index < 5; index++) {
        UIView *optionCell = [self makeOptionCellWithTitle:[optionTitles objectAtIndex:index] tag:kOptionButtonTag + index hasArrow:YES];
        [optionCell setFrame:CGRectMake(0, y, kAppWidth, fScreen(88))];
        [optionView addSubview:optionCell];
        y += fScreen(88);
    }
}

- (UIView *)makeOptionCellWithTitle:(NSString *)title tag:(NSInteger)tag hasArrow:(BOOL)hasArrow
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [titleLabel setText:title];
    [cellView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.top.right.bottom.equalTo(cellView);
    }];
    
    // 是否有箭头
    if (hasArrow) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more"]];
        [cellView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cellView.mas_right).offset(-fScreen(30));
            make.centerY.equalTo(cellView.mas_centerY);
            make.width.mas_equalTo(fScreen(14));
            make.height.mas_equalTo(fScreen(24));
        }];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [cellView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(cellView);
        make.height.equalTo(@1);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setTag:tag];
    [cellView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(cellView);
    }];
    
    return cellView;
}

- (void)showActionSheet
{
    if (!self.actionSheetCover) {
        UIView *cover = [[UIView alloc] init];
        [cover setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4f]];
        [self.view addSubview:cover];
        [cover mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.view);
        }];
        self.actionSheetCover = cover;
        
        UIView *optionView = [[UIView alloc] init];
        [optionView setBackgroundColor:[UIColor whiteColor]];
        [optionView.layer setCornerRadius:fScreen(26)];
        [optionView.layer setMasksToBounds:YES];
        [cover addSubview:optionView];
        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cover.mas_left).offset(fScreen(20));
            make.right.equalTo(cover.mas_right).offset(-fScreen(20));
            make.height.mas_equalTo(fScreen(240));
            make.bottom.equalTo(cover.mas_bottom).offset(-fScreen(24 + 114 + 20));
        }];
        
        UIButton *button1 = [[UIButton alloc] init];
        [button1.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [button1 setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [button1 setTitle:@"确定要清空所有缓存数据?" forState:UIControlStateNormal];
        [optionView addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(optionView);
            make.height.mas_equalTo(fScreen(120));
        }];
        
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:HexColor(0xdadada)];
        [optionView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(optionView);
            make.height.equalTo(@1);
            make.centerY.equalTo(optionView.mas_centerY);
        }];
        
        UIButton *button2 = [[UIButton alloc] init];
        [button2 setTag:0];
        [button2.titleLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
        [button2 setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
        [button2 setTitle:@"清除缓存" forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(actionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
        [optionView addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(optionView);
            make.height.mas_equalTo(fScreen(120));
        }];
        
        
        UIButton *escButton = [[UIButton alloc] init];
        [escButton setBackgroundColor:[UIColor whiteColor]];
        [escButton.layer setCornerRadius:fScreen(26)];
        [escButton.layer setMasksToBounds:YES];
        [escButton setTitle:@"取消" forState:UIControlStateNormal];
        [escButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [escButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
        [escButton setTag:1];
        [escButton addTarget:self action:@selector(actionSheetClick:) forControlEvents:UIControlEventTouchUpInside];
        [cover addSubview:escButton];
        [escButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(optionView);
            make.top.equalTo(optionView.mas_bottom).offset(fScreen(20));
            make.height.mas_equalTo(fScreen(114));
        }];
    }
    if (self.actionSheetCover.alpha != 1) {
        [UIView animateWithDuration:0.3f animations:^{
            self.actionSheetCover.alpha = 1;
            [self.actionSheetCover setHidden:NO];
        }];
    }
}

- (void)hideActionSheet
{
    [UIView animateWithDuration:0.3f animations:^{
        self.actionSheetCover.alpha = 0;
        [self.actionSheetCover setHidden:YES];
    }];
}


#pragma mark - button click

- (void)loginButtonClick:(UIButton *)sender
{
    if ([HDUserDefaults objectForKey:cUserid] != nil) {
        
    }
    else {
        LoginViewController *loginController = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginController animated:YES];
    }
}

- (void)optionButtonClick:(UIButton *)sender
{
    UIViewController *toViewController;
    
    NSInteger tag = sender.tag - kOptionButtonTag;
    
    switch (tag) {
        case 0:
            default:
            // 个人资料
        {
            toViewController = [[UserInfoViewController alloc] init];
        }
            break;
        case 1:
            // 账户设置
        {
            toViewController = [[AccountSettingController alloc] init];
        }
            break;
        case 2:
        {
            toViewController = [[APNSSettingController alloc] init];
        }
            break;
        case 3:
            // 意见反馈
        {
            toViewController = [[FeedBackController alloc] init];
        }
            break;
        case 4:
            // 关于
        {
            toViewController = [[AboutAppController alloc] init];
        }
            break;
        case 100:
            // 清除缓存
            [self showActionSheet];
            return;
    }
    [self.navigationController pushViewController:toViewController animated:YES];
}

- (void)actionSheetClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            // 清除缓存
        {
            SDImageCache *webCache = [[SDImageCache alloc] init];
            [webCache clearMemory];
            [webCache clearDiskOnCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"已经清空缓存" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil, nil];
                    [alert show];
                });
            }];
        }
            break;
        case 1:
        default:
            // 取消
            [self hideActionSheet];
            break;
    }
}


@end

//
//  BaseViewController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "BaseViewController.h"

#import "MYTabBarController.h"
#import "AppDelegate.h"
#import <Masonry.h>


@interface BaseViewController () <UIGestureRecognizerDelegate>


@end

@implementation BaseViewController

#pragma mark
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    __weak typeof(self) weakSelf = self;
    
    // 自定义返回按钮添加返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}


#pragma mark
#pragma mark - Public
- (void)setBadgValue:(NSString *)value index:(NSInteger)index
{
    [[MYTabBarController sharedTabBarController] setTabBarItemValue:value index:index];
}

- (void)showTabBar
{
    [self.navigationController.tabBarController.tabBar setHidden:NO];
}

- (void)hideTabBar
{
    [self.navigationController.tabBarController.tabBar setHidden:YES];
}

- (void)showNavigationBar
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)hideNavigationBar
{
    [self.navigationController.navigationBar setHidden:YES];
}

- (UIButton *)makeBackButton
{
    UIButton *backButton = [[UIButton alloc] init];
    [backButton setImage:[UIImage imageNamed:@"jiantou-(1)"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return backButton;
}

- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)makeTitleLabelWithTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:title];
    [titleLabel setFont:[UIFont systemFontOfSize:viewControllerTitleFontSize]];
    [titleLabel setTextColor:viewControllerTitleColor];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    CGSize textSize = [titleLabel.text sizeForFontsize:viewControllerTitleFontSize];
    [titleLabel setFrame:CGRectMake(0, 0, textSize.width + 4, textSize.height)];
    return titleLabel;
}

- (UIView *)addTitleViewWithTitle:(NSString *)titleText
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88) + 20);
    }];
    
    UIButton *backButton = [self makeBackButton];
    [titleView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.centerY.equalTo(titleView.mas_centerY).offset(10);
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(28*2 + 38));
    }];
    
    UILabel *titleLabel = [self makeTitleLabelWithTitle:titleText];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(titleView);
        make.height.mas_equalTo(fScreen(88));
    }];
    self.titleLabel = titleLabel;
    
    return titleView;
}


- (UIViewController *)topViewController
{
    UIViewController *rootVC = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        // navigationController
        return [rootVC.navigationController topViewController];
    }
    else if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // tabbarController
        return (UIViewController *)[(UITabBarController *)rootVC selectedViewController];
    }
    else {
        // viewController
        return rootVC;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

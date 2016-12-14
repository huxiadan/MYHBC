//
//  MainTestController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MainTestController.h"
#import <Masonry.h>

#import "BaiXianBaiPinController.h"
#import "GroupBuyController.h"
#import "GroupbuyOrderController.h"
#import "StoreViewController.h"

@interface MainTestController ()

@end

@implementation MainTestController

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
    UIButton *baixianbaipinButton = [[UIButton alloc] init];
    [baixianbaipinButton setTitle:@"百县百品" forState:UIControlStateNormal];
    [baixianbaipinButton setBackgroundColor:[UIColor grayColor]];
    [baixianbaipinButton addTarget:self action:@selector(baixianbaipinButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:baixianbaipinButton];
    [baixianbaipinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(fScreen(40));
        make.top.equalTo(self.view).offset(fScreen(100));
        make.height.mas_equalTo(fScreen(88));
        make.width.mas_equalTo(fScreen(160));
    }];
    
    UIButton *groupbuyButton = [[UIButton alloc] init];
    [groupbuyButton setTitle:@"千县拼团" forState:UIControlStateNormal];
    [groupbuyButton setBackgroundColor:[UIColor redColor]];
    [groupbuyButton addTarget:self action:@selector(groupbuyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:groupbuyButton];
    [groupbuyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(baixianbaipinButton.mas_right).offset(fScreen(40));
        make.top.with.height.equalTo(baixianbaipinButton);
    }];
    
    UIButton *addGroupButton = [[UIButton alloc] init];
    [addGroupButton setTitle:@"加入拼团" forState:UIControlStateNormal];
    [addGroupButton setBackgroundColor:[UIColor  blueColor]];
    [addGroupButton addTarget:self action:@selector(addGroupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addGroupButton];
    [addGroupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(groupbuyButton.mas_right).offset(fScreen(40));
        make.top.with.height.equalTo(groupbuyButton);
    }];
    
    UIButton *shopButton = [[UIButton alloc] init];
    [shopButton setTitle:@"店铺" forState:UIControlStateNormal];
    [shopButton setBackgroundColor:[UIColor  blueColor]];
    [shopButton addTarget:self action:@selector(shopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shopButton];
    [shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addGroupButton.mas_right).offset(fScreen(40));
        make.top.with.height.equalTo(addGroupButton);
    }];
}

#pragma mark - button click
- (void)baixianbaipinButtonClick:(UIButton *)sender
{
    BaiXianBaiPinController *baixianVC = [[BaiXianBaiPinController alloc] init];
    
    [self.currNavigationController pushViewController:baixianVC animated:YES];
}

- (void)groupbuyButtonClick:(UIButton *)sender
{
    GroupBuyController *groupVC = [[GroupBuyController alloc] init];
    [self.currNavigationController pushViewController:groupVC animated:YES];
}

- (void)addGroupButtonClick:(UIButton *)sender
{
    GroupbuyOrderController *orderVC = [[GroupbuyOrderController alloc] initWithTitle:@"水果" groupId:@""];
    [self.currNavigationController pushViewController:orderVC animated:YES];
}

- (void)shopButtonClick:(UIButton *)sender
{
    StoreViewController *storeVC = [[StoreViewController alloc] init];
    [self.currNavigationController pushViewController:storeVC animated:YES];
}

@end

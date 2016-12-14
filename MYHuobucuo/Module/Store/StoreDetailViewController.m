//
//  StoreDetailViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreDetailViewController.h"
#import <Masonry.h>
#import "HDLabel.h"

@interface StoreDetailViewController ()

@property (nonatomic, strong) UIView *contactView;      // 联系方式(电话/地址)
@property (nonatomic, strong) UIView *introView;        // 简介
@property (nonatomic, strong) UIView *noticeView;       // 公告

// data
@property (nonatomic, copy) NSString *phoneNumberString;    // 电话号码
@property (nonatomic, copy) NSString *addressString;        // 地址
@property (nonatomic, copy) NSString *introString;          // 简介
@property (nonatomic, copy) NSString *noticeString;         // 公告

//@property (nonatomic, assign) CGFloat height;

@end

@implementation StoreDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    self.phoneNumberString = @"12345678900";
    self.addressString = @"胡建省厦门市思明区莲前街道软件园二期望海路63号楼";
    self.introString = @"重要的事情说三遍: 买了我的瓜忘了那个他; 买了我的瓜忘了那个他; 买了我的瓜忘了那个他;";
    self.noticeString = @"满200送张全蛋语录全集, 满999送王尼玛丝袜一双, 满1999送如花写真3套,多买多得";
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    // 电话地址
    self.contactView = [self makeContactView];
    [self.view addSubview:self.contactView];
    
    // 简介
    self.introView = [self makeIntroView];
    [self.view addSubview:self.introView];
    
    // 公告
    if (self.noticeString.length > 0) {
        self.noticeView = [self makeNoticeView];
        [self.view addSubview:self.noticeView];
        
        self.height = CGRectGetMaxY(self.noticeView.frame);
    }
    else {
        self.height = CGRectGetMaxY(self.introView.frame);
    }
}

- (UIView *)makeNoticeView
{
    UIView *noticeView = [[UIView alloc] init];
    [noticeView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [self titleLabel];
    [titleLabel setText:@"店铺公告"];
    [noticeView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noticeView).offset(fScreen(28));
        make.height.mas_equalTo(fScreen(32));
        make.right.equalTo(noticeView);
        make.top.equalTo(noticeView).offset(fScreen(28));
    }];
    
    HDLabel *contentLabel = [self contentLabelWithWidth:(kAppWidth - fScreen(28 + 28))];
    [contentLabel setNumberOfLines:0];
    [contentLabel setText:self.noticeString];

    [noticeView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noticeView).offset(fScreen(28));
        make.right.equalTo(noticeView).offset(-fScreen(28));
        make.top.equalTo(titleLabel.mas_bottom).offset(fScreen(16));
        make.height.mas_equalTo(contentLabel.textHeight);
    }];

    [noticeView setFrame:CGRectMake(0, CGRectGetMaxY(self.introView.frame) + fScreen(20), kAppWidth, fScreen(26 + 32 + 16 + 26) + contentLabel.textHeight)];
    
    return noticeView;
}

- (UIView *)makeIntroView
{
    UIView *introView = [[UIView alloc] init];
    [introView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [self titleLabel];
    [titleLabel setText:@"店铺简介:"];
    [introView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(introView).offset(fScreen(28));
        make.top.equalTo(introView).offset(fScreen(28));
        make.height.mas_equalTo(fScreen(32));
        make.right.equalTo(introView).offset(-fScreen(28));
    }];
    
    HDLabel *contentLabel = [self contentLabelWithWidth:(kAppWidth - fScreen(28 + 28))];
    [contentLabel setText:self.introString];
    [contentLabel setNumberOfLines:0];
    
    [introView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(fScreen(16));
        make.height.mas_equalTo(contentLabel.textHeight);
    }];
    
    [introView setFrame:CGRectMake(0, CGRectGetMaxY(self.contactView.frame) + fScreen(20), kAppWidth, fScreen(28 + 32 + 18 + 28) + contentLabel.textHeight)];
    
    return introView;
}

- (UIView *)makeContactView
{
    UIView *contactView = [[UIView alloc] init];
    [contactView setBackgroundColor:[UIColor whiteColor]];
    
    // 电话
    UIView *phoneView = [[UIView alloc] init];
    [contactView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(contactView);
        make.height.mas_equalTo(fScreen(86));
    }];
    
    UIImageView *phoneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_phone_store"]];
    [phoneView addSubview:phoneIcon];
    [phoneIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView).offset(fScreen(28));
        make.centerY.equalTo(phoneView);
        make.size.mas_equalTo(CGSizeMake(fScreen(38), fScreen(38)));
    }];
    
    UILabel *phoneTitle = [self titleLabel];
    [phoneTitle setText:@"联系电话"];
    [phoneView addSubview:phoneTitle];
    [phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneIcon.mas_right).offset(fScreen(20));
        make.centerY.top.bottom.equalTo(phoneIcon);
        make.width.mas_equalTo(fScreen(140));
    }];
    
    UILabel *phoneNum = [self contentLabelWithWidth:kAppWidth];
    [phoneNum setTextAlignment:NSTextAlignmentRight];
    [phoneNum setText:self.phoneNumberString];
    [contactView addSubview:phoneNum];
    [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(phoneView).offset(-fScreen(28));
        make.centerY.equalTo(phoneTitle);
        make.height.mas_equalTo(fScreen(28));
        make.left.equalTo(phoneTitle.mas_right).offset(fScreen(20));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [phoneView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneView).offset(fScreen(28));
        make.right.equalTo(phoneView).offset(-fScreen(28));
        make.height.mas_equalTo(@1);
        make.bottom.equalTo(phoneView);
    }];
    
    // 地址
    UIImageView *addrIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_add"]];
    [contactView addSubview:addrIcon];
    [addrIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom).offset(fScreen(26));
        make.left.equalTo(contactView).offset(fScreen(28));
        make.size.mas_equalTo(CGSizeMake(fScreen(38), fScreen(38)));
    }];
    
    UILabel *addrTitle = [self titleLabel];
    [addrTitle setText:@"地址"];
    [contactView addSubview:addrTitle];
    [addrTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addrIcon.mas_right).offset(fScreen(20));
        make.top.bottom.equalTo(addrIcon);
        make.width.mas_equalTo(fScreen(74));
    }];
    
    HDLabel *addressLabel = [self contentLabelWithWidth:(kAppWidth - fScreen(28 + 38 + 20 + 28))];
    [addressLabel setNumberOfLines:2];
    [addressLabel setText:self.addressString];
    
    
    
    [contactView addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contactView).offset(fScreen(28 + 38 + 20));
        make.top.equalTo(addrTitle.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(addressLabel.textHeight);
        make.right.equalTo(contactView).offset(-fScreen(28));
    }];
    
    [contactView setFrame:CGRectMake(0, fScreen(20), kAppWidth, fScreen(86 + 20 + 38 + 20 + 20) + addressLabel.textHeight)];
    
    return contactView;
}

- (UILabel *)titleLabel
{
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [label setTextColor:HexColor(0x333333)];
    return label;
}

- (HDLabel *)contentLabelWithWidth:(CGFloat)width
{
    HDLabel *label = [[HDLabel alloc] init];
    [label setWidth:width];
    [label setLineSpace:fScreen(14)];
    [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [label setTextColor:HexColor(0x666666)];
    return label;
}

@end

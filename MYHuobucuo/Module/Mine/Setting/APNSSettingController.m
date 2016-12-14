//
//  APNSSettingController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/4.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "APNSSettingController.h"
#import <Masonry.h>

#define kAPNS @"消息推送"
#define kVoice @"声音震动"
#define kDetail @"通知详情显示"
#define kAtNight @"夜间防骚扰模式"

@interface APNSSettingController ()

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) NSDictionary *tagDict;    // key:title valeu:YES/NO

@property (nonatomic, strong) UIButton *voiceButton;
@property (nonatomic, strong) UIButton *detailButton;
@property (nonatomic, strong) UIButton *nightButton;

@end

@implementation APNSSettingController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tagDict = @{kAPNS :[NSNumber numberWithInteger:1],
                     kVoice :[NSNumber numberWithInteger:2],
                     kDetail :[NSNumber numberWithInteger:3],
                     kAtNight :[NSNumber numberWithInteger:4]
                     };
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"消息推送"];
    
    CGFloat width = kAppWidth;
    CGFloat height = fScreen(88);
    
    // 消息推送
    UIView *view1 = [[UIView alloc] init];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88)*2 - 1);
    }];
    
    {
        UIView *oneCellView1 = [self makeOptionCellWithTitle:kAPNS hasSwitchControl:YES];
        UIView *oneCellView2 = [self makeOptionCellWithTitle:@"开启后，可以收到新的推送消息" hasSwitchControl:NO];
        [oneCellView1 setFrame:CGRectMake(0, 0, width, height)];
        [oneCellView2 setFrame:CGRectMake(0, height, width, height)];
        
        [view1 addSubview:oneCellView1];
        [view1 addSubview:oneCellView2];
    }
    
    // 声音震动
    UIView *view2 = [self makeOptionCellWithTitle:kVoice hasSwitchControl:YES];
    [view2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(view1.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88) - 1);
    }];
    
    // 通知详情显示
    UIView *view3 = [[UIView alloc] init];
    [view3 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view3];
    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(view2.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88)*2 - 1);
    }];
    
    {
        UIView *thirdCellView1 = [self makeOptionCellWithTitle:kDetail hasSwitchControl:YES];
        UIView *thirdCellView2 = [self makeOptionCellWithTitle:@"开启后，当收到客服消息时，通知提示将显示发件人的内容摘要" hasSwitchControl:NO];
        
        [thirdCellView1 setFrame:CGRectMake(0, 0, width, height)];
        [thirdCellView2 setFrame:CGRectMake(0, height, width, height)];
        
        [view3 addSubview:thirdCellView1];
        [view3 addSubview:thirdCellView2];
    }
    
    // 夜间防骚扰
    UIView *view4 = [[UIView alloc] init];
    [view4 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view4];
    [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(view3.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88)*2 - 1);
    }];
    
    {
        UIView *fourCellView1 = [self makeOptionCellWithTitle:kAtNight hasSwitchControl:YES];
        UIView *fourCellView2 = [self makeOptionCellWithTitle:@"开启后，货不错将自动屏蔽23:00-8:00间的任何提示" hasSwitchControl:NO];
        
        [fourCellView1 setFrame:CGRectMake(0, 0, width, height)];
        [fourCellView2 setFrame:CGRectMake(0, height, width, height)];
        
        [view4 addSubview:fourCellView1];
        [view4 addSubview:fourCellView2];
    }
}

- (UIView *)makeOptionCellWithTitle:(NSString *)titleText hasSwitchControl:(BOOL)hasSwitch
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *label = [[UILabel alloc] init];
    [label setText:titleText];
    [label setFont:[UIFont systemFontOfSize:hasSwitch ? fScreen(28) : fScreen(24)]];
    [label setTextColor:HexColor(0x666666)];
    [cellView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.top.equalTo(cellView);
        make.right.equalTo(cellView.mas_right).offset(-fScreen(20));
    }];
    
    if (hasSwitch) {
        UIButton *switchButton = [[UIButton alloc] init];
        [switchButton setImage:[UIImage imageNamed:@"button_off"] forState:UIControlStateNormal];
        [switchButton setImage:[UIImage imageNamed:@"button_on@2x"] forState:UIControlStateSelected];
        [switchButton setSelected:YES];
        [switchButton setTag:[[self.tagDict objectForKey:titleText] integerValue]];
        [switchButton addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:switchButton];
        [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cellView.mas_right).offset(-fScreen(30));
            make.centerY.equalTo(cellView.mas_centerY);
            make.height.mas_equalTo(fScreen(48));
            make.width.mas_equalTo(fScreen(96));
        }];
        
        if ([titleText isEqualToString:kAPNS]) {
            [switchButton setSelected:[[HDUserDefaults objectForKey:cUserSettingAPNS] boolValue]];
        }
        else if ([titleText isEqualToString:kVoice]) {
            self.voiceButton = switchButton;
            [switchButton setSelected:[[HDUserDefaults objectForKey:cUserSettingVoice] boolValue]];
        }
        else if ([titleText isEqualToString:kDetail]) {
            self.detailButton = switchButton;
            [switchButton setSelected:[[HDUserDefaults objectForKey:cUserSettingAPNSDetail] boolValue]];
        }
        else if ([titleText isEqualToString:kAtNight]) {
            self.nightButton = switchButton;
            [switchButton setSelected:[[HDUserDefaults objectForKey:cUserSettingNotDisturbAtNight] boolValue]];
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [cellView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(cellView);
        make.height.equalTo(@1);
    }];
    
    return cellView;
}

- (void)switchValueChange:(UISwitch *)sender
{
    sender.selected = !sender.isSelected;
    
    switch (sender.tag) {
        case 1:
            // 消息推送
            [HDUserDefaults setObject:[NSNumber numberWithBool:sender.selected] forKey:cUserSettingAPNS];
            if (sender.selected == NO) {
                // 其他按钮都为 no
                [HDUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:cUserSettingVoice];
                [HDUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:cUserSettingAPNSDetail];
                [HDUserDefaults setObject:[NSNumber numberWithBool:NO] forKey:cUserSettingNotDisturbAtNight];
                
                [self.voiceButton setSelected:NO];
                [self.detailButton setSelected:NO];
                [self.nightButton setSelected:NO];
            }
            break;
        case 2:
            // 声音震动
            [HDUserDefaults setObject:[NSNumber numberWithBool:sender.selected] forKey:cUserSettingVoice];
            break;
        case 3:
            // 通知详情显示
            [HDUserDefaults setObject:[NSNumber numberWithBool:sender.selected] forKey:cUserSettingAPNSDetail];
            break;
        case 4:
            // 夜间防骚扰模式
            [HDUserDefaults setObject:[NSNumber numberWithBool:sender.selected] forKey:cUserSettingNotDisturbAtNight];
            break;
        default:
            break;
    }
    [HDUserDefaults synchronize];
}



@end

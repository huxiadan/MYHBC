//
//  EvaluateTabHeader.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "EvaluateTabHeader.h"
#import <Masonry.h>

#define kEvaluateBtnNormalBGColor   [UIColor whiteColor]
#define kEvaluateBtnSelectedBGColor HexColor(0xffccd4)

#define kEvaluateBtnNormalBorderColor   HexColor(0x999999)
#define kEvaluateBtnSelectedBorderColor HexColor(0xe44a62)

@interface EvaluateTabHeader ()

@property (nonatomic, strong) UIButton *currButton;

@end

@implementation EvaluateTabHeader

- (instancetype)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    UIView *buttonView = [[UIView alloc] init];
    [buttonView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:buttonView];
    [buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(1);
        make.height.mas_equalTo(fScreen(88));
    }];
    
    CGFloat x = fScreen(28);
    CGFloat y = fScreen(18);
    CGFloat width = fScreen(116);
    CGFloat height = fScreen(48);
    for (NSInteger index = 0; index < 4; index++) {
        UIButton *button = [self makeButtonWithTag:index];
        [button setFrame:CGRectMake(x, y, width, height)];
        x += width + fScreen(26);
        [buttonView addSubview:button];
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(fScreen(10));
    }];
}

- (UIButton *)makeButtonWithTag:(EvaluateHeaderTag)tag
{
    UIButton *button = [[UIButton alloc] init];
    
    [button setBackgroundColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [button setTitleColor:kEvaluateBtnNormalBorderColor forState:UIControlStateNormal];
    [button setTitleColor:kEvaluateBtnSelectedBorderColor forState:UIControlStateSelected];
    button.layer.borderColor = kEvaluateBtnNormalBorderColor.CGColor;
    button.layer.borderWidth = 1.0f;
    [button.layer setCornerRadius:fScreen(24)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    switch (tag) {
        case EvaluateHeaderTag_All:
        default:
            [button setTitle:@"全部" forState:UIControlStateNormal];
            
            button.selected = YES;
            button.layer.borderColor = kEvaluateBtnSelectedBorderColor.CGColor;
            [button setBackgroundColor:kEvaluateBtnSelectedBGColor];
            
            self.currButton = button;
            break;
        case EvaluateHeaderTag_Best:
            [button setTitle:@"好评" forState:UIControlStateNormal];
            break;
        case EvaluateHeaderTag_Good:
            [button setTitle:@"中评" forState:UIControlStateNormal];
            break;
        case EvaluateHeaderTag_Bad:
            [button setTitle:@"差评" forState:UIControlStateNormal];
            break;
    }
    
    return button;
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender != self.currButton) {
        self.currButton.selected = NO;
        [self.currButton.layer setBorderColor:kEvaluateBtnNormalBorderColor.CGColor];
        [self.currButton setTitleColor:kEvaluateBtnNormalBorderColor forState:UIControlStateNormal];
        [self.currButton setBackgroundColor:kEvaluateBtnNormalBGColor];
        
        sender.selected = YES;
        [sender.layer setBorderColor:kEvaluateBtnSelectedBorderColor.CGColor];
        [sender setTitleColor:kEvaluateBtnSelectedBorderColor forState:UIControlStateNormal];
        [sender setBackgroundColor:kEvaluateBtnSelectedBGColor];
        
        if (self.buttonBlock) {
            self.buttonBlock(sender.tag);
        }
        
        self.currButton = sender;
    }
}

@end

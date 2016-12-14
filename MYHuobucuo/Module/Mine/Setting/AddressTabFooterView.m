//
//  AddressTabFooterView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressTabFooterView.h"
#import <Masonry.h>

@implementation AddressTabFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"button_add"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(fScreen(40));
        make.width.mas_equalTo(fScreen(680));
        make.height.mas_equalTo(fScreen(88));
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end

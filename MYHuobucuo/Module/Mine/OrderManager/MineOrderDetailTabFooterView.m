//
//  MineOrderDetailTabFooterView.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/25.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineOrderDetailTabFooterView.h"
#import <Masonry.h>

@interface MineOrderDetailTabFooterView ()

@property (nonatomic, strong) UILabel *payMoneyLabel;

@end

@implementation MineOrderDetailTabFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *infoLabel = [[UILabel alloc] init];
    [infoLabel setText:@"实际支付"];
    [infoLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [infoLabel setTextColor:HexColor(0x666666)];
    [self addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(28));
        make.centerY.equalTo(self.mas_centerY).offset(-fScreen(10));
        CGSize textSize = [infoLabel.text sizeForFontsize:fScreen(26)];
        make.width.mas_equalTo(textSize.width + 4);
        make.height.mas_equalTo(textSize.height);
    }];
    
    UILabel *payMoneyLabel = [[UILabel alloc] init];
    [payMoneyLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [payMoneyLabel setTextColor:HexColor(0xe44a62)];
    [payMoneyLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:payMoneyLabel];
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.centerY.equalTo(infoLabel.mas_centerY);
        make.left.equalTo(infoLabel.mas_right).offset(fScreen(20));
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.payMoneyLabel = payMoneyLabel;
}

- (void)setPayMoney:(NSString *)payMoney
{
    NSString *payString = [NSString stringWithFormat:@"¥%@",payMoney];
    [self.payMoneyLabel setText:payString];
}

@end

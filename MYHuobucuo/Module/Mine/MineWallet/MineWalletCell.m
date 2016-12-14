//
//  MineWalletCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineWalletCell.h"

#import <Masonry.h>

#define ZeroMoneyColor HexColor(0x999999)
#define MoneyColor HexColor(0xe44a62)

@interface MineWalletCell ()

@property (strong, nonatomic) UIImageView *iconView;

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UILabel *moneyLabel;

@end

@implementation MineWalletCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self.layer setCornerRadius:8.f];
        
        self.iconView = [[UIImageView alloc] init];
        [self.iconView.layer setCornerRadius:10.f];
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(fScreen(40));
            make.width.mas_equalTo(fScreen(50));
            make.height.mas_equalTo(fScreen(50));
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [self.titleLabel setTextColor:HexColor(0x666666)];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconView.mas_bottom).offset(fScreen(10));
            make.left.right.equalTo(self);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
            make.height.mas_equalTo(textSize.height);
        }];
        
        self.moneyLabel = [[UILabel alloc] init];
        [self.moneyLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [self.moneyLabel setTextColor:ZeroMoneyColor];
        [self.moneyLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.moneyLabel];
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(fScreen(28));
            make.left.right.equalTo(self);
            CGSize textSize = [@"高度"  sizeForFontsize:fScreen(32)];
            make.height.mas_equalTo(textSize.height);
        }];
    }
    return self;
}



- (void)setDataWithTitle:(NSString *)title money:(NSString *)money imageName:(NSString *)imageName
{
    [self.titleLabel setText:title];
    [self.iconView setImage:[UIImage imageNamed:imageName]];
    
    UIColor *textColor = [money floatValue] != 0 ? HexColor(0xe44a62) : HexColor(0x999999);
    NSMutableAttributedString *string;
    money = [NSString stringWithFormat:@"¥ %@",money];
    string = [[NSMutableAttributedString alloc] initWithString:money];
    // ¥
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(22)]}
                    range:NSMakeRange(0, 1)];
    // 金额
    [string addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} range:NSMakeRange(2, string.length - 2)];

    [string addAttributes:@{NSForegroundColorAttributeName : textColor} range:NSMakeRange(0, string.length)];
    
    [self.moneyLabel setAttributedText:string];
}

@end

//
//  MineOrderTabFooterView.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineOrderTabFooterView.h"
#import <Masonry.h>

@interface MineOrderTabFooterView ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) OrderShopState state;

@end

@implementation MineOrderTabFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 合计 label
        UILabel *infoLabel = [[UILabel alloc] init];
        [infoLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [infoLabel setTextColor:HexColor(0x666666)];
        [infoLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-fScreen(28));
            make.left.equalTo(self.mas_left).offset(fScreen(28));
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
            make.height.mas_equalTo(textSize.height);
            make.top.equalTo(self.mas_top).offset((fScreen(68 - 10) - textSize.height)/2);
        }];
        self.infoLabel = infoLabel;
        
        // 横线
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:viewControllerBgColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@1);
            make.top.equalTo(self.mas_top).offset(fScreen(68 - 10));        // 减10是因为 cell 底部还有10间距的白色边
        }];
        
        // 右边的按钮
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [rightButton setBackgroundColor:[UIColor whiteColor]];
        [rightButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
        [rightButton.layer setBorderColor:HexColor(0xe44a62).CGColor];
        [rightButton.layer setBorderWidth:1.0f];
        [rightButton.layer setCornerRadius:5.f];
        [rightButton.layer setMasksToBounds:YES];
        [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-fScreen(28));
            make.top.equalTo(lineView.mas_bottom).offset(fScreen(10));
            make.width.mas_equalTo(fScreen(146));
            make.height.mas_equalTo(fScreen(58));
        }];
        self.rightButton = rightButton;
        
        // 左边的按钮
        UIButton *leftButton = [[UIButton alloc] init];
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [leftButton setBackgroundColor:HexColor(0x666666)];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton.layer setCornerRadius:5.f];
        [leftButton.layer setMasksToBounds:YES];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftButton.mas_left).offset(-fScreen(20));
            make.top.equalTo(lineView.mas_bottom).offset(fScreen(10));
            make.width.height.equalTo(leftButton);
        }];
        self.leftButton = leftButton;
    }
    return self;
}

- (void)leftButtonClick:(UIButton *)sender
{
    if (self.leftButtonBlock) {
        self.leftButtonBlock(self.state);
    }
}

- (void)rightButtonClick:(UIButton *)sender
{
    if (self.rightButtonBlock) {
        self.rightButtonBlock(self.state);
    }
}

- (void)setOrderShopModel:(OrderShopModel *)orderShopModel
{
    self.state = orderShopModel.state;
    
    NSString *infoString = [NSString stringWithFormat:@"共%ld件商品 合计: ¥%@", orderShopModel.goodsCount, orderShopModel.goodsAmount];
    [self.infoLabel setText:infoString];
    
    switch (orderShopModel.state) {
        case OrderShopState_WaitPay:
        {
            [self.rightButton setTitle:@"付款" forState:UIControlStateNormal];
            [self.leftButton setTitle:@"取消订单" forState:UIControlStateNormal];
            [self.leftButton setBackgroundColor:HexColor(0x666666)];
            [self.leftButton setHidden:NO];
        }
            break;
            
        case OrderShopState_WaitSend:
        {
            [self.rightButton setTitle:@"提醒发货" forState:UIControlStateNormal];
            [self.leftButton setHidden:YES];
        }
            break;
            
        case OrderShopState_WaitReceive:
        {
            [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.leftButton setBackgroundColor:HexColor(0xe44b62)];
            [self.leftButton setHidden:NO];
        }
            break;
        
        case OrderShopState_WaitEvaluate:
        {
            [self.rightButton setTitle:@"评价" forState:UIControlStateNormal];
            [self.leftButton setTitle:@"查看物流" forState:UIControlStateNormal];
            [self.leftButton setBackgroundColor:HexColor(0x666666)];
            [self.leftButton setHidden:NO];
        }
            break;

        default:
            break;
    }
}

@end

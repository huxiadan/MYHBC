//
//  MineGroupOrderTabFooter.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineGroupOrderTabFooter.h"
#import <Masonry.h>

@interface MineGroupOrderTabFooter ()

@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *stateButton;            // 状态(拼团成功/拼团失败)

@property (nonatomic, assign) OrderShopState state;

@end

@implementation MineGroupOrderTabFooter

#define kGroupSuccessImage @""
#define kGroupFailImage    @""

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
        [leftButton setTitle:@"查看拼团详情" forState:UIControlStateNormal];
        [leftButton setBackgroundColor:HexColor(0x666666)];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton.layer setCornerRadius:5.f];
        [leftButton.layer setMasksToBounds:YES];
        [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(leftButton.mas_left).offset(-fScreen(20));
            make.top.equalTo(lineView.mas_bottom).offset(fScreen(10));
            make.height.equalTo(leftButton);
            make.width.mas_equalTo(fScreen(180));
        }];
        self.leftButton = leftButton;
        
        // 状态
        UIButton *stateButton = [[UIButton alloc] init];
        [stateButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(22)]];
        [stateButton setEnabled:NO];
        [stateButton setImageEdgeInsets:UIEdgeInsetsMake(0, fScreen(10), 0, 0)];
        [stateButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -fScreen(10))];
        self.stateButton = stateButton;
        [self stateButtonSuccess];
    }
    return self;
}

- (void)stateButtonSuccess
{
    [self.stateButton setTitle:@"拼团成功" forState:UIControlStateNormal];
    [self.stateButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [self.stateButton setImage:[UIImage imageNamed:kGroupSuccessImage] forState:UIControlStateNormal];
}

- (void)stateButtonFail
{
    [self.stateButton setTitle:@"拼团失败" forState:UIControlStateNormal];
    [self.stateButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [self.stateButton setImage:[UIImage imageNamed:kGroupFailImage] forState:UIControlStateNormal];
}

#pragma mark - button click
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

#pragma mark - setter
- (void)setOrderShopModel:(OrderShopModel *)orderShopModel
{
    self.state = orderShopModel.state;
    
    NSString *infoString = [NSString stringWithFormat:@"共%ld件商品 合计: ¥%@", orderShopModel.goodsCount, orderShopModel.goodsAmount];
    [self.infoLabel setText:infoString];
    
    switch (orderShopModel.state) {
            // 待成团
        case OrderShopState_WaitPay:
        {
            [self.rightButton setTitle:@"邀请好友拼团" forState:UIControlStateNormal];
            [self.leftButton setBackgroundColor:HexColor(0x666666)];
            [self.leftButton setHidden:NO];
        }
            break;
            // 拼团成功
        case OrderShopState_WaitSend:
        {
            [self.rightButton setTitle:@"再拼一单" forState:UIControlStateNormal];
            [self.leftButton setHidden:NO];
        }
            break;
            // 待收货
        case OrderShopState_WaitReceive:
        {
            [self.rightButton setTitle:@"确认收货" forState:UIControlStateNormal];
            [self.leftButton setTitle:@"查看物流详情" forState:UIControlStateNormal];
            [self.leftButton setHidden:NO];
        }
            break;
            // 待评价
        case OrderShopState_WaitEvaluate:
        {
            [self.rightButton setTitle:@"评价" forState:UIControlStateNormal];
            [self.leftButton setBackgroundColor:HexColor(0x666666)];
            [self.leftButton setHidden:YES];
        }
            break;
            // 已完成,拼团成功
        case OrderShopState_Over_Success:
        {
            [self.rightButton setTitle:@"再拼一单 " forState:UIControlStateNormal];
            [self.leftButton setHidden:YES];
        }
            break;
            // 已完成,拼团失败
        case OrderShopState_Over_Fail:
        {
            [self.rightButton setTitle:@"再拼一单 " forState:UIControlStateNormal];
            [self.leftButton setHidden:YES];
        }
            break;
            
        default:
            break;
    }
}

@end

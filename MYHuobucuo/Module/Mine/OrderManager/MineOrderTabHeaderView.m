//
//  MineOrderTabHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineOrderTabHeaderView.h"
#import "OrderShopModel.h"
#import <Masonry.h>

@interface MineOrderTabHeaderView ()

@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UILabel *shopStateLabel;

@end

@implementation MineOrderTabHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *boldLineView = [[UIView alloc] init];
        [boldLineView setBackgroundColor:viewControllerBgColor];
        [self addSubview:boldLineView];
        [boldLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.mas_equalTo(fScreen(20));
        }];
        
        UIImageView *shopImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"店铺"]];
        [self addSubview:shopImageView];
        [shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(fScreen(28));
            make.centerY.equalTo(self.mas_centerY).offset(fScreen(10));
            make.width.mas_equalTo(fScreen(36));
            make.height.mas_equalTo(fScreen(36));
        }];
        
        UILabel *shopStateLabel = [[UILabel alloc] init];
        [shopStateLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [shopStateLabel setTextColor:HexColor(0xe44a62)];
        [shopStateLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:shopStateLabel];
        [shopStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-fScreen(28));
            make.centerY.equalTo(shopImageView.mas_centerY);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
            make.width.mas_equalTo(fScreen(120));
            make.height.mas_equalTo(textSize.height);
        }];
        self.shopStateLabel = shopStateLabel;
        
        UILabel *shopNameLabel = [[UILabel alloc] init];
        [shopNameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [self addSubview:shopNameLabel];
        [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shopImageView.mas_right).offset(5);
            make.right.equalTo(shopStateLabel.mas_left).offset(5);
            make.centerY.equalTo(shopImageView.mas_centerY);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
            make.height.mas_equalTo(textSize.height);
        }];
        self.shopNameLabel = shopNameLabel;
    }
    return self;
}

- (void)setOrderShopModel:(OrderShopModel *)orderShopModel
{
    [self.shopNameLabel setText:orderShopModel.shopName];
    
    NSString *orderShopStateString;
    
    switch (orderShopModel.state) {
        case OrderShopState_WaitPay:
            orderShopStateString = @"待付款";
            break;
        case OrderShopState_WaitSend:
            orderShopStateString = @"待发货";
            break;
        case OrderShopState_WaitReceive:
            orderShopStateString = @"待收货";
            break;
        case OrderShopState_WaitEvaluate:
            orderShopStateString = @"待评价";
            break;
        case OrderShopState_NoShow:
        default:
            orderShopStateString = @"";
            break;
    }
    [self.shopStateLabel setText:orderShopStateString];
}

@end

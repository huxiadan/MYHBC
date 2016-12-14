//
//  GoodsDetailBottomView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsDetailBottomView.h"
#import "HDButton.h"
#import <Masonry.h>

@implementation GoodsDetailBottomView

- (instancetype)init
{
    if (self = [super init]) {

        [self setBackgroundColor:[UIColor whiteColor]];
        
        // 客服
        HDButton *serviceButton = [[HDButton alloc] init];
        [serviceButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [serviceButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [serviceButton setTitle:@"客服" forState:UIControlStateNormal];
        [serviceButton setImage:[UIImage imageNamed:@"客服-(3)"] forState:UIControlStateNormal];
        serviceButton.imageTitleType = HDImageTitleBottomTitle;
        [serviceButton addTarget:self action:@selector(serviceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:serviceButton];
        [serviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(fScreen(46 + 20*2));
            make.left.equalTo(self.mas_left).offset(fScreen(46 - 20));
        }];
        
        // 店铺
        HDButton *toShopButton = [[HDButton alloc] init];
        [toShopButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [toShopButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [toShopButton setTitle:@"店铺" forState:UIControlStateNormal];
        [toShopButton setImage:[UIImage imageNamed:@"店铺---副本"] forState:UIControlStateNormal];
        toShopButton.imageTitleType = HDImageTitleBottomTitle;
        [toShopButton addTarget:self action:@selector(toShopButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:toShopButton];
        [toShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(fScreen(46 + 20*2));
            make.left.equalTo(serviceButton.mas_right).offset(fScreen(72 - 20*2));
        }];
        
        // 收藏
        HDButton *collectButton = [[HDButton alloc] init];
        [collectButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [collectButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"collect_goodsDedtail_n"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"collect_goodsDedtail_s"] forState:UIControlStateSelected];
        collectButton.imageTitleType = HDImageTitleBottomTitle;
        [collectButton addTarget:self action:@selector(collectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:collectButton];
        [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(fScreen(46 + 20*2));
            make.left.equalTo(toShopButton.mas_right).offset(fScreen(72 - 20*2));
        }];
        
        // 加入购物车
        UIButton *addShoppingCarButton = [[UIButton alloc] init];
        [addShoppingCarButton setBackgroundColor:HexColor(0xf9b40c)];
        [addShoppingCarButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [addShoppingCarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addShoppingCarButton setTitle:@"加入购物车" forState:UIControlStateNormal];
        [addShoppingCarButton addTarget:self action:@selector(addShoppingCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addShoppingCarButton];
        [addShoppingCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-fScreen(188));
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(fScreen(188));
        }];
        
        // 立即付款
        UIButton *payButton = [[UIButton alloc] init];
        [payButton setBackgroundColor:HexColor(0x999999)];
        [payButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [payButton setTitle:@"立即付款" forState:UIControlStateNormal];
        [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:payButton];
        [payButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right);
            make.top.bottom.equalTo(self);
            make.width.mas_equalTo(fScreen(188));
        }];
    }
    return self;
}

#pragma mark - button click
// 跳转店铺页面
- (void)toShopButtonClick:(UIButton *)sender
{
    if (self.toShopBlock) {
        self.toShopBlock();
    }
}

// 客服跳转
- (void)serviceButtonClick:(UIButton *)sender
{
    if (self.serviceBlock) {
        self.serviceBlock();
    }
}

// 收藏
- (void)collectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (self.collectBlock) {
        self.collectBlock();
    }
}

// 加入购物车
- (void)addShoppingCarButtonClick:(UIButton *)sender
{
    if (self.addShopCarBlock) {
        self.addShopCarBlock();
    }
}

// 立即付款
- (void)payButtonClick:(UIButton *)sender
{
    if (self.payBlock) {
        self.payBlock();
    }
}


@end

//
//  ShoppingCarHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShoppingCarHeaderView.h"
#import <Masonry.h>

@interface ShoppingCarHeaderView ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *arrowImageViwe;
@property (nonatomic, strong) UIButton *editButton;

@end

@implementation ShoppingCarHeaderView

- (instancetype)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(fScreen(20));
    }];
    
    
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_s"] forState:UIControlStateSelected];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_n"] forState:UIControlStateNormal];
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(30 - 10));
        make.centerY.equalTo(self.mas_centerY).offset(fScreen(10));
        make.width.mas_equalTo(fScreen(40 + 10*2));
        make.height.mas_equalTo(fScreen(40 + 10*2));
    }];
    self.selectButton = selectButton;
    
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"icon_shop"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(30 + 40 + 30));
        make.centerY.equalTo(selectButton.mas_centerY);
        make.width.mas_equalTo(fScreen(32));
        make.height.mas_equalTo(fScreen(32));
    }];
    
    
    // 编辑
    UIButton *editButton = [[UIButton alloc] init];
    [editButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [editButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editButton];
    [editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView.mas_centerY);
        make.right.equalTo(self);
        CGSize textSize = [editButton.titleLabel.text sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width + fScreen(30*2));
        make.height.mas_equalTo(textSize.height);
    }];
    self.editButton = editButton;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameLabel setTextColor:HexColor(0x666666)];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(20));
        make.centerY.equalTo(imageView.mas_centerY);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width);
        make.height.mas_equalTo(textSize.height);
    }];
    self.shopNameLabel = nameLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [arrowImageView setImage:[UIImage imageNamed:@"icon_more"]];
    [self addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(fScreen(20));
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.width.mas_equalTo(fScreen(14));
        make.height.mas_equalTo(fScreen(24));
    }];
    self.arrowImageViwe = arrowImageView;
    
    UIButton *shopNameButton = [[UIButton alloc] init];
    [shopNameButton addTarget:self action:@selector(shopNameButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shopNameButton];
    [shopNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.right.equalTo(editButton.mas_left).offset(-fScreen(10));
        make.top.bottom.equalTo(self);
    }];
}

- (void)selectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    self.shopModel.isSelect = sender.isSelected;
    
    if (self.selectAllBlock) {
        self.selectAllBlock();
    }
}

- (void)editButtonClick:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        self.shopModel.isEdit = YES;
    }
    else {
        self.shopModel.isEdit = NO;
    }
    
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)shopNameButtonClick:(UIButton *)sender
{
    if (self.storeBlock) {
        self.storeBlock(self.shopModel.shopId);
    }
}

- (void)setShopModel:(OrderShopModel *)shopModel
{
    _shopModel = shopModel;
    
    self.selectButton.selected = shopModel.isSelect;
    
    if (shopModel.isEdit) {
        [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    else {
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    [self.shopNameLabel setText:shopModel.shopName];
    CGSize textSize = [shopModel.shopName sizeForFontsize:fScreen(28)];
    [self.shopNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width + 2);
    }];
    
    [self.arrowImageViwe layoutIfNeeded];
    
    [self.editButton setHidden:shopModel.isEditAll];
}

@end

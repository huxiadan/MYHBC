//
//  StoreGoodsCollCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreGoodsCollCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import "HDLabel.h"

@interface StoreGoodsCollCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) HDLabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *goodsPriceLabel;
@property (nonatomic, strong) UILabel *goodsMarketLabel;
@property (nonatomic, strong) UIButton *addShoppingCarButton;
@property (nonatomic, strong) UIImageView *groupImageView;

@end

@implementation StoreGoodsCollCell

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
    [self.layer setCornerRadius:fScreen(8)];
    [self.layer setMasksToBounds:YES];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(fScreen(336));
        make.width.mas_equalTo(fScreen(336));
    }];
    self.goodsImageView = imageView;
    
    // 拼团标识
    UIImageView *groupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tuangou-"]];
    [imageView addSubview:groupImageView];
    [groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(imageView).offset(-fScreen(20));
        make.height.width.mas_equalTo(fScreen(68));
    }];
    self.groupImageView = groupImageView;
    groupImageView.hidden = YES;
    
    UIButton *addShopCarButton = [[UIButton alloc] init];
    [addShopCarButton setImage:[UIImage imageNamed:@"icon_sp-cart"] forState:UIControlStateNormal];
    [addShopCarButton addTarget:self action:@selector(addShoppingCarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addShopCarButton];
    [addShopCarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(fScreen(30 + 20*2));
        make.height.mas_equalTo(fScreen(30 + 20*2));
    }];
    self.addShoppingCarButton = addShopCarButton;
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(20));
        make.bottom.equalTo(self.mas_bottom).offset(-fScreen(16));
        make.width.equalTo(@1);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(32)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.goodsPriceLabel = priceLabel;
    
    UILabel *marketPrickLabel = [[UILabel alloc] init];
    [marketPrickLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [marketPrickLabel setTextColor:HexColor(0x999999)];
    [self addSubview:marketPrickLabel];
    [marketPrickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceLabel.mas_right).offset(fScreen(20));
        make.centerY.equalTo(priceLabel.mas_centerY);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
        make.right.equalTo(addShopCarButton.mas_left).offset(-fScreen(20));
    }];
    self.goodsMarketLabel = marketPrickLabel;
    
    HDLabel *nameLabel = [[HDLabel alloc] init];
    [nameLabel setNumberOfLines:0];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(20));
        make.right.equalTo(self.mas_right).offset(-fScreen(20));
        //        make.bottom.equalTo(priceLabel.mas_top).offset(-fScreen(10));
        make.top.equalTo(imageView.mas_bottom).offset(fScreen(10));
        
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(26)];
        make.height.mas_equalTo(textSize.height * 2 + 2);
    }];
    self.goodsNameLabel = nameLabel;
}

- (void)setGoodsModel:(StoreGoodsModel *)goodsModel
{
    _goodsModel = goodsModel;
    
    [self.goodsNameLabel setText:goodsModel.goodsName];
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.goodsImageURL] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    
    [self.groupImageView setHidden:goodsModel.groupBuy];
    
    NSMutableAttributedString *priceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",goodsModel.goodsPrice]];
    [priceString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]} range:NSMakeRange(0, 1)];
    [priceString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} range:NSMakeRange(1, priceString.length - 1)];
    [self.goodsPriceLabel setAttributedText:priceString];
    
    CGSize textSize = [[NSString stringWithFormat:@"￥ %@",goodsModel.goodsPrice] sizeForFontsize:fScreen(32)];
    [self.goodsPriceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width);
    }];
    
    NSMutableAttributedString *marketPriceString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥ %@",goodsModel.marketPrice]];
    [marketPriceString addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, marketPriceString.length)];
    [self.goodsMarketLabel setAttributedText:marketPriceString];
    [self.goodsMarketLabel layoutIfNeeded];
}

- (void)addShoppingCarButtonClick:(UIButton *)sender
{
    if (self.addShoppingCarBlock) {
        self.addShoppingCarBlock(self.goodsModel);
    }
}

@end

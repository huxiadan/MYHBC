//
//  StoreGoodsTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreGoodsTabCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface StoreGoodsTabCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;  // 图片
@property (nonatomic, strong) UILabel *goodsNameLabel;      // 名称
@property (nonatomic, strong) UILabel *goodsPriceLabel;     // 金额
@property (nonatomic, strong) UIButton *collectionButton;   // 收藏按钮
@property (nonatomic, strong) UIButton *shareButton;        // 分享按钮
@property (nonatomic, strong) UIView *lineView;             // 底部横线
@property (nonatomic, strong) UILabel *postageLabel;        // 邮费
@property (nonatomic, strong) UIImageView *groupImageView;  // 团购标识图片

@end

@implementation StoreGoodsTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 图片
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(fScreen(240));
        make.height.mas_equalTo(fScreen(240));
    }];
    self.goodsImageView = goodsImageView;
    
    // 团购标识图片
    UIImageView *groupImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_tuangou-"]];
    [goodsImageView addSubview:groupImageView];
    [groupImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(goodsImageView).offset(-fScreen(12));
        make.height.width.mas_equalTo(fScreen(68));
    }];
    self.groupImageView = groupImageView;
    groupImageView.hidden = YES;
    
    // 名称
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    [goodsNameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [goodsNameLabel setTextColor:HexColor(0x333333)];
    [goodsNameLabel setNumberOfLines:2];
    [self addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.top.equalTo(self.mas_top).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(28));
    }];
    self.goodsNameLabel = goodsNameLabel;
    
    // 邮费
    UILabel *postageLabel = [[UILabel alloc] init];
    [postageLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [postageLabel setTextColor:HexColor(0x999999)];
    [postageLabel setText:@"包邮"];
    [self addSubview:postageLabel];
    [postageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(30));
        make.centerY.equalTo(goodsImageView);
        make.height.mas_equalTo(fScreen(24));
        make.right.equalTo(self);
    }];
    
    // 金额
    UILabel *goodsPriceLabel = [[UILabel alloc] init];
    [goodsPriceLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [goodsPriceLabel setTextColor:HexColor(0xe44a62)];
    [self addSubview:goodsPriceLabel];
    [goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.bottom.equalTo(self.mas_bottom).offset(-fScreen(20));
        CGSize textSzie = [@"高度" sizeForFontsize:fScreen(32)];
        make.height.mas_equalTo(textSzie.height);
        make.width.mas_equalTo(fScreen(220));
    }];
    self.goodsPriceLabel = goodsPriceLabel;
    
    // 分享按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"store_icon_share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-fScreen(58 - 20));
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(fScreen(34 + 20*2));
        make.height.mas_equalTo(fScreen(34 + 20*2));
    }];
    self.shareButton = shareButton;
    
    // 收藏按钮
    UIButton *collButton = [[UIButton alloc] init];
    [collButton setImage:[UIImage imageNamed:@"store_icon_collect_n"] forState:UIControlStateNormal];
    [collButton setImage:[UIImage imageNamed:@"store_icon_collect_f"] forState:UIControlStateSelected];
    [collButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collButton];
    [collButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left).offset(-fScreen(88 - 20 - 20));
        make.centerY.equalTo(shareButton.mas_centerY);
        make.width.mas_equalTo(fScreen(36 + 20*2));
        make.height.mas_equalTo(fScreen(36 + 20*2));
    }];
    self.collectionButton = collButton;
    
    // 底部横线
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.equalTo(@2);
    }];
    self.lineView = lineView;
}

- (void)setModel:(StoreGoodsModel *)model
{
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
    [self adjustNameLabelWithText:model.goodsName];
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.goodsPrice]];
    self.collectionButton.selected = model.collected;
    [self.groupImageView setHidden:model.groupBuy];
}

// 分享按钮
- (void)shareButtonClick:(UIButton *)sender
{
    if (self.shareBlock) {
        self.shareBlock(self.model.shareModel);
    }
}

// 收藏按钮
- (void)collectionButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (self.collectBlock) {
        self.collectBlock(self.collectionButton.isSelected);
    }
}

- (void)adjustNameLabelWithText:(NSString *)text
{
    [self.goodsNameLabel setText:text];
    
    CGFloat labelWidth = kAppWidth - fScreen(30 + 200 + 20 + 28);;
    
    CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize textSize = [self.goodsNameLabel.text boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.goodsNameLabel.font} context:nil].size;
    
    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textSize.height > fScreen(70) ? fScreen(70) : textSize.height);
    }];
}


@end

//
//  CollGoodsCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CollGoodsCell.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface CollGoodsCell ()

@property (nonatomic, strong) UIButton *selectButton;       // 选择按钮
@property (nonatomic, strong) UIImageView *goodsImageView;  // 图片
@property (nonatomic, strong) UILabel *goodsNameLabel;      // 名称
@property (nonatomic, strong) UILabel *goodsPriceLabel;     // 金额
@property (nonatomic, strong) UIButton *collectionButton;   // 收藏按钮
@property (nonatomic, strong) UIButton *shareButton;        // 分享按钮
@property (nonatomic, strong) UIImageView *invalidLabel;    // 已失效 label
@property (nonatomic, strong) UIView *lineView;             // 底部横线

@property (nonatomic, assign) BOOL isEdit;                  // cell 进入编辑状态 UI 需要更新

@end

@implementation CollGoodsCell

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
    
    // 选择按钮
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_n"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_s"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(-fScreen(50));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(fScreen(60));
        make.height.mas_equalTo(fScreen(200));
    }];
    self.selectButton = selectButton;
    
    // 图片
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    [goodsImageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton.mas_right).offset(fScreen(20));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(fScreen(200));
        make.height.mas_equalTo(fScreen(200));
    }];
    self.goodsImageView = goodsImageView;
    
    // 名称
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    [goodsNameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [goodsNameLabel setTextColor:HexColor(0x333333)];
    [goodsNameLabel setNumberOfLines:2];
    [self addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.right.equalTo(self.mas_right).offset(-fScreen(40));
        make.top.equalTo(goodsImageView.mas_top);
        make.height.mas_equalTo(fScreen(28));
    }];
    self.goodsNameLabel = goodsNameLabel;
    
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
    [shareButton setImage:[UIImage imageNamed:@"button_share_n-"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"button_share_h"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(fScreen(-20));
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(fScreen(40 + 20*2));
        make.height.mas_equalTo(fScreen(40 + 20*2));
    }];
    self.shareButton = shareButton;
    
    // 收藏按钮
    UIButton *collButton = [[UIButton alloc] init];
    [collButton setImage:[UIImage imageNamed:@"button_save_s"] forState:UIControlStateNormal];
    [collButton setImage:[UIImage imageNamed:@"button_save_n"] forState:UIControlStateSelected];
    [collButton addTarget:self action:@selector(collectionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:collButton];
    [collButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(shareButton.mas_left).offset(-fScreen(40));
        make.centerY.equalTo(shareButton.mas_centerY);
        make.width.mas_equalTo(fScreen(30 + 20*2));
        make.height.mas_equalTo(fScreen(30 + 20*2));
    }];
    self.collectionButton = collButton;
    
    // 已失效
    UIImageView *invalidLabel = [[UIImageView alloc] init];
    [invalidLabel setImage:[UIImage imageNamed:@"lab_shixiao"]];
    [self addSubview:invalidLabel];
    [invalidLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(goodsImageView.mas_centerY);
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(68));
        make.height.mas_equalTo(fScreen(28));
    }];
    self.invalidLabel = invalidLabel;
    [invalidLabel setHidden:YES];
    
    // 底部横线
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self);
        make.height.equalTo(@1);
        make.left.equalTo(goodsImageView.mas_left);
    }];
    self.lineView = lineView;
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    
    if (isEdit) {
        [self.selectButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(fScreen(20));
        }];
    }
    else {
        [self.selectButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(-fScreen(60));
        }];
    }
    [self.goodsImageView layoutIfNeeded];
    [self.goodsNameLabel layoutIfNeeded];
    [self.goodsPriceLabel layoutIfNeeded];
    [self.lineView layoutIfNeeded];
}

- (void)setModel:(CollGoodsModel *)model
{
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageURL] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    [self adjustNameLabelWithText:model.goodsName];
    [self.goodsPriceLabel setText:[NSString stringWithFormat:@"￥%@", model.goodsPrice]];
    self.isEdit = model.isEdit;
    self.invalidLabel.hidden = !model.isInvalid;
    self.collectionButton.selected = YES;
}

- (void)selectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    self.model.isSelected = sender.isSelected;
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
        self.collectBlock(sender.isSelected);
    }
}

- (void)adjustNameLabelWithText:(NSString *)text
{
    [self.goodsNameLabel setText:text];
    
    CGFloat labelWidth = kAppWidth - fScreen(30 + 200 + 20 + 40);;
    if (self.isEdit) {
        labelWidth -= fScreen(30 + 40);
    }
    
    CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize textSize = [self.goodsNameLabel.text boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.goodsNameLabel.font} context:nil].size;

    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textSize.height > fScreen(70) ? fScreen(70) : textSize.height);
    }];
}

@end

//
//  GroupbuyMasterFreeTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyMasterFreeTabCell.h"

@interface GroupbuyMasterFreeTabCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *groupCountLabel;
@property (nonatomic, strong) UIImageView *groupCountImage;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *goodsSpecLabel;

@end

@implementation GroupbuyMasterFreeTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    // 免单图片
    UIImageView *freeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_miandan"]];
    [self.bContentView addSubview:freeImageView];
    [freeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bContentView).offset(fScreen(20));
        make.top.equalTo(self.bContentView);
        make.width.mas_equalTo(fScreen(408));
        make.height.mas_equalTo(fScreen(56));
    }];
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [nameLabel setNumberOfLines:2];
    [nameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bContentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bContentView).offset(fScreen(20));
        make.right.equalTo(self.bContentView).offset(-fScreen(20));
        make.height.mas_equalTo(fScreen(32));
        make.top.equalTo(self.goodsImageView.mas_bottom).offset(fScreen(20));
    }];
    self.goodsNameLabel = nameLabel;
    
    // 规格
    UILabel *specLabel = [[UILabel alloc] init];
    [specLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [specLabel setTextColor:HexColor(0x5560f1)];
    [self.bContentView addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(nameLabel);
        make.height.mas_equalTo(fScreen(24));
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(20));
    }];
    self.goodsSpecLabel = specLabel;
    
    // 拼团人数
    UILabel *personCountLabel = [[UILabel alloc] init];
    [personCountLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [personCountLabel setTextColor:HexColor(0x999999)];
    [personCountLabel setTextAlignment:NSTextAlignmentRight];
    [personCountLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bContentView addSubview:personCountLabel];
    [personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(20));
        make.bottom.equalTo(self.bContentView.mas_bottom).offset(-fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(75));
    }];
    self.groupCountLabel = personCountLabel;
    
    UIImageView *countImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-tuandui"]];
    [self.bContentView addSubview:countImage];
    [countImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.groupCountLabel);
        make.right.equalTo(self.groupCountLabel.mas_left).offset(-fScreen(10));
        make.width.mas_equalTo(fScreen(26));
        make.height.mas_equalTo(fScreen(26));
    }];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(48)]];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [self.bContentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bContentView).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(48));
        make.width.mas_equalTo(fScreen(500));
        make.baseline.equalTo(self.groupCountLabel.mas_baseline);
    }];
    self.priceLabel = priceLabel;
}

- (void)setModel:(BaiXianBaiPinModel *)model
{
    _model = model;
    
    // 图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
    
    // 人数
    NSString *countString = [NSString stringWithFormat:@"%ld人团",model.personCount];
    self.groupCountLabel.text = countString;
    
    // 价格
    NSString *priceString = [NSString stringWithFormat:@"拼团价 ￥%@", model.price];
    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attrPrice addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} range:NSMakeRange(0, 3)];
    [attrPrice addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(28)]} range:NSMakeRange(4, 1)];
    
    self.priceLabel.attributedText = attrPrice;
    
    // 名称
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];
    CGFloat containWidth = kAppWidth - fScreen(20*2) - fScreen(20*2);
    CGFloat height = [self.goodsNameLabel caculateHeightWithWidth:containWidth];
    
    CGFloat towLineHeight = fScreen(32*2 + 12);
    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height > towLineHeight ? towLineHeight : height);
    }];
    [self.goodsSpecLabel layoutIfNeeded];
    
    // 规格
    self.goodsSpecLabel.text = model.goodsSpec;
}

@end

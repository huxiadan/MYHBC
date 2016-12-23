//
//  BaiXianBaiPinMasterFreeTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BaiXianBaiPinMasterFreeTabCell.h"
#import "UILabel+HD.h"
#import <UIImageView+WebCache.h>

@interface  BaiXianBaiPinMasterFreeTabCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;      // 商品名
@property (nonatomic, strong) UILabel *goodsSpecLabel;      // 规格
@property (nonatomic, strong) UILabel *priceLabel;          // 价格
@property (nonatomic, strong) UILabel *personCountLabel;    // 成团人数

@end

@implementation BaiXianBaiPinMasterFreeTabCell

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
    // 团长免单图片
    UIImageView *freeImageView = [[UIImageView alloc] init];
    [freeImageView setImage:[UIImage imageNamed:@"titel_miandan"]];
    [self.bContentView addSubview:freeImageView];
    [freeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(fScreen(20));
        make.top.right.equalTo(self.bContentView);
        make.height.mas_equalTo(fScreen(48));
    }];
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [nameLabel setNumberOfLines:2];
    [nameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bContentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(fScreen(30));
        make.top.equalTo(freeImageView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(28));
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(30));
    }];
    self.goodsNameLabel = nameLabel;
    
    // 规格
    UILabel *specLabel = [[UILabel alloc] init];
    [specLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [specLabel setTextColor:HexColor(0x5560f1)];
    [self.bContentView addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(fScreen(30));
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(20));
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(24));
    }];
    self.goodsSpecLabel = specLabel;
    
    // 成团人数
    UILabel *personCountLabel = [[UILabel alloc] init];
    [personCountLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [personCountLabel setTextColor:HexColor(0x999999)];
    [personCountLabel setTextAlignment:NSTextAlignmentRight];
    [self.bContentView addSubview:personCountLabel];
    [personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(30));
        make.bottom.equalTo(self.bContentView.mas_bottom).offset(-fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(90));
    }];
    self.personCountLabel = personCountLabel;
    
    // 拼团价
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(48)]];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [self.bContentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(fScreen(30));
        make.height.mas_equalTo(fScreen(48));
        make.right.equalTo(personCountLabel.mas_left).offset(-fScreen(10));
        make.baseline.equalTo(self.personCountLabel.mas_baseline);
    }];
    self.priceLabel = priceLabel;
}

- (void)setModel:(BaiXianBaiPinModel *)model
{
    _model = model;
    
    // 图片
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    
    // 人数
    NSString *countString = [NSString stringWithFormat:@"%ld人团",model.personCount];
    self.personCountLabel.text = countString;
    
    // 价格
    NSString *priceString = [NSString stringWithFormat:@"拼团价 ￥%@", model.price];
    NSMutableAttributedString *attrPrice = [[NSMutableAttributedString alloc] initWithString:priceString];
    [attrPrice addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} range:NSMakeRange(0, 3)];
    [attrPrice addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(28)]} range:NSMakeRange(4, 1)];
    
    self.priceLabel.attributedText = attrPrice;

    // 名称
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@", model.goodsName];
    CGFloat containWidth = kAppWidth - fScreen(20 * 2) - fScreen(280) - fScreen(30 * 2);
    CGFloat height = [self.goodsNameLabel caculateHeightWithWidth:containWidth];
    
    CGFloat towLineHeight = fScreen(28*2 + 12);
    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height > towLineHeight ? towLineHeight : height);
    }];
    [self.goodsSpecLabel layoutIfNeeded];
    
    // 规格
    self.goodsSpecLabel.text = model.goodsSpec;
}

@end

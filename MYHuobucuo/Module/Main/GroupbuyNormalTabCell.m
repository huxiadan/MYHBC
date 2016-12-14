//
//  GroupbuyNormalTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyNormalTabCell.h"

@interface GroupbuyNormalTabCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *groupCountLabel;
@property (nonatomic, strong) UIImageView *groupCountImage;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIImageView *backMoneyView;   // 佣金背景图
@property (nonatomic, strong) UILabel *commissionTitle;     // 佣金标题
@property (nonatomic, strong) UILabel *commissionContent;   // 佣金内容

@end

@implementation GroupbuyNormalTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
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
    
    // 拼团人数
    UIImageView *countImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-tuandui"]];
    [self.bContentView addSubview:countImage];
    [countImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bContentView.mas_bottom).offset(-fScreen(20));
        make.left.equalTo(self.bContentView).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(26));
        make.height.mas_equalTo(fScreen(26));
    }];
    
    UILabel *personCountLabel = [[UILabel alloc] init];
    [personCountLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [personCountLabel setTextColor:HexColor(0x999999)];
    [personCountLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bContentView addSubview:personCountLabel];
    [personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countImage.mas_right).offset(fScreen(10));
        make.centerY.equalTo(countImage);
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(75));
    }];
    self.groupCountLabel = personCountLabel;
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(48)]];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [priceLabel setTextAlignment:NSTextAlignmentRight];
    [self.bContentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bContentView).offset(-fScreen(20));
        make.height.mas_equalTo(fScreen(48));
        make.width.mas_equalTo(fScreen(500));
        make.baseline.equalTo(self.groupCountLabel.mas_baseline);
    }];
    self.priceLabel = priceLabel;
    
    // 佣金
    UIImageView *backMoney = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_yongjin"]];
    [self.bContentView addSubview:backMoney];
    [backMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bContentView).offset(fScreen(20));
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(490));
        make.height.mas_equalTo(fScreen(40));
    }];
    self.backMoneyView = backMoney;
    
    // 佣金标题
    UILabel *commissionTitleLabel = [[UILabel alloc] init];
    [commissionTitleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [commissionTitleLabel setTextColor:[UIColor whiteColor]];
    [backMoney addSubview:commissionTitleLabel];
    [commissionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backMoney);
        make.left.equalTo(backMoney.mas_left).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(100));
    }];
    self.commissionTitle = commissionTitleLabel;
    
    // 佣金内容
    UILabel *commissionContentLabel = [[UILabel alloc] init];
    [commissionContentLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [commissionContentLabel setTextColor:HexColor(0xe79433)];
    [backMoney addSubview:commissionContentLabel];
    [commissionContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backMoney);
        make.left.equalTo(commissionTitleLabel.mas_right).offset(fScreen(60));
        make.height.mas_equalTo(fScreen(24));
        make.right.equalTo(backMoney.mas_right).offset(-fScreen(10));
    }];
    self.commissionContent = commissionContentLabel;
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
    CGFloat containWidth = kAppWidth - fScreen(20 * 2) - fScreen(280) - fScreen(30 * 2);
    CGFloat height = [self.goodsNameLabel caculateHeightWithWidth:containWidth];
    
    CGFloat towLineHeight = fScreen(28*2 + 12);
    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height > towLineHeight ? towLineHeight : height);
    }];
    
    // 佣金
    [self.backMoneyView layoutIfNeeded];
    
    self.commissionTitle.text = model.commissionTitle;
    self.commissionContent.text = model.commissionContent;
}

@end

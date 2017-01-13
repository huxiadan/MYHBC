//
//  BaiXianBaiPinLimitTimeTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BaiXianBaiPinLimitTimeTabCell.h"
#import "UILabel+HD.h"
#import <UIImageView+WebCache.h>

@interface BaiXianBaiPinLimitTimeTabCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;      // 商品名
@property (nonatomic, strong) UILabel *marketPriceLabel;    // 市场价
@property (nonatomic, strong) UILabel *priceLabel;          // 价格
@property (nonatomic, strong) UILabel *personCountLabel;    // 成团人数

@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation BaiXianBaiPinLimitTimeTabCell

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
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [nameLabel setNumberOfLines:2];
    [nameLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bContentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(fScreen(30));
        make.top.equalTo(self.bContentView).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(28));
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(30));
    }];
    self.goodsNameLabel = nameLabel;
    
    // 倒计时
    UIView *countDownView = [[UIView alloc] init];
    [countDownView setBackgroundColor:HexColor(0xe44a62)];
    [self.bContentView addSubview:countDownView];
    [countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right);
        make.bottom.right.equalTo(self.bContentView);
        make.height.mas_equalTo(fScreen(62));
    }];
    
    // 时间背景
    // 秒
    UILabel *secondLabel = [self timeLabel];
    [countDownView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(countDownView).offset(-fScreen(20));
        make.centerY.equalTo(countDownView);
        make.width.mas_equalTo(fScreen(30));
        make.height.mas_equalTo(fScreen(30));
    }];
    self.secondLabel = secondLabel;
    
    UIImageView *colonView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colon"]];
    [countDownView addSubview:colonView1];
    [colonView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondLabel.mas_left);
        make.centerY.equalTo(secondLabel);
        make.width.mas_equalTo(fScreen(6));
        make.height.mas_equalTo(fScreen(14));
    }];
    
    // 分
    UILabel *minLabel = [self timeLabel];
    [countDownView addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonView1.mas_left);
        make.centerY.width.height.equalTo(secondLabel);
    }];
    self.minLabel = minLabel;
    
    UIImageView *colonView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colon"]];
    [countDownView addSubview:colonView2];
    [colonView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minLabel.mas_left);
        make.centerY.width.height.equalTo(colonView1);
    }];
    
    // 小时
    UILabel *hourLabel = [self timeLabel];
    [countDownView addSubview:hourLabel];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonView2.mas_left);
        make.centerY.width.height.equalTo(secondLabel);
    }];
    self.hourLabel = hourLabel;
    
    UILabel *limitLabel = [[UILabel alloc] init];
    [limitLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [limitLabel setTextColor:[UIColor whiteColor]];
    [limitLabel setTextAlignment:NSTextAlignmentRight];
    [limitLabel setText:@"距结束"];
    [countDownView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hourLabel.mas_left).offset(-fScreen(20));
        make.centerY.equalTo(countDownView);
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(100));
    }];
    
    // 成团人数
    UILabel *personCountLabel = [[UILabel alloc] init];
    [personCountLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [personCountLabel setTextColor:[UIColor whiteColor]];
    [countDownView addSubview:personCountLabel];
    [personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(countDownView.mas_left).offset(fScreen(30));
        make.centerY.equalTo(countDownView.mas_centerY);
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
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(30));
        make.bottom.equalTo(countDownView.mas_top).offset(-fScreen(20));
    }];
    self.priceLabel = priceLabel;
    
    // 原价
    UILabel *marketLabel = [[UILabel alloc] init];
    [marketLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [marketLabel setTextColor:HexColor(0x999999)];
    [self.bContentView addSubview:marketLabel];
    [marketLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(fScreen(30));
        make.bottom.equalTo(priceLabel.mas_top).offset(-fScreen(10));
        make.right.equalTo(self.bContentView.mas_right).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(28));
    }];
    self.marketPriceLabel = marketLabel;

}

- (UILabel *)timeLabel
{
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4f]];
    [label setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setCornerRadius:fScreen(5)];
    [label.layer setMasksToBounds:YES];
    
    return label;
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

    // 市场价
    NSMutableAttributedString *marketString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model.marketPrice]];
    [marketString addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)} range:NSMakeRange(0, marketString.length)];
    self. marketPriceLabel.attributedText = marketString;
    
    // 倒计时
    NSArray *timeArray = [self getTime:model.countDownTime];
    self.hourLabel.text   = [NSString stringWithFormat:@"%02ld", [timeArray[0] integerValue]];
    self.minLabel.text    = [NSString stringWithFormat:@"%02ld", [timeArray[1] integerValue]];
    self.secondLabel.text = [NSString stringWithFormat:@"%02ld", [timeArray[2] integerValue]];
}

- (void)setTime:(NSUInteger)time
{
    _time = time;
    
    NSArray *timeArray = [self getTime:time];
    self.hourLabel.text   = [NSString stringWithFormat:@"%02ld", [timeArray[0] integerValue]];
    self.minLabel.text    = [NSString stringWithFormat:@"%02ld", [timeArray[1] integerValue]];
    self.secondLabel.text = [NSString stringWithFormat:@"%02ld", [timeArray[2] integerValue]];
}

- (NSArray *)getTime:(NSUInteger)seconds
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
    
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    [tmpArray addObject:[NSNumber numberWithInteger:hour]];
    [tmpArray addObject:[NSNumber numberWithInteger:min]];
    [tmpArray addObject:[NSNumber numberWithInteger:second]];
    
    return [tmpArray copy];
}

@end

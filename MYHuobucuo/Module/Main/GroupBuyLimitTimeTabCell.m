//
//  GroupBuyLimitTimeTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupBuyLimitTimeTabCell.h"

@interface GroupBuyLimitTimeTabCell ()

@property (nonatomic, strong) UILabel *goodsNameLabel;
@property (nonatomic, strong) UILabel *groupCountLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *goodsSpecLabel;

@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation GroupBuyLimitTimeTabCell

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
    
    // 倒计时
    UIView *timeDownView = [[UIView alloc] init];
    [timeDownView setBackgroundColor:HexColor(0xe44a62)];
    [self.bContentView addSubview:timeDownView];
    [timeDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.bContentView);
        make.height.mas_equalTo(fScreen(88));
    }];
    
    // 时间
    // 秒
    UILabel *secondLabel = [self timeLabel];
    [timeDownView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeDownView).offset(-fScreen(30));
        make.centerY.equalTo(timeDownView);
        make.width.mas_equalTo(fScreen(40));
        make.height.mas_equalTo(fScreen(40));
    }];
    self.secondLabel = secondLabel;
    
    UIImageView *colonView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colon"]];
    [timeDownView addSubview:colonView1];
    [colonView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondLabel.mas_left).offset(-2);
        make.centerY.equalTo(secondLabel);
        make.width.mas_equalTo(fScreen(6));
        make.height.mas_equalTo(fScreen(14));
    }];
    
    // 分
    UILabel *minLabel = [self timeLabel];
    [timeDownView addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonView1.mas_left).offset(-2);
        make.centerY.width.height.equalTo(secondLabel);
    }];
    self.minLabel = minLabel;
    
    UIImageView *colonView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colon"]];
    [timeDownView addSubview:colonView2];
    [colonView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(minLabel.mas_left).offset(-2);
        make.centerY.width.height.equalTo(colonView1);
    }];
    
    // 小时
    UILabel *hourLabel = [self timeLabel];
    [timeDownView addSubview:hourLabel];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(colonView2.mas_left).offset(-2);
        make.centerY.width.height.equalTo(secondLabel);
    }];
    self.hourLabel = hourLabel;
    
    UILabel *limitLabel = [[UILabel alloc] init];
    [limitLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [limitLabel setTextColor:[UIColor whiteColor]];
    [limitLabel setTextAlignment:NSTextAlignmentRight];
    [limitLabel setText:@"限时抢"];
    [timeDownView addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(hourLabel.mas_left).offset(-fScreen(30));
        make.centerY.equalTo(timeDownView);
        make.height.mas_equalTo(fScreen(28));
        make.width.mas_equalTo(fScreen(100));
    }];

    
    // 拼团人数
    UILabel *personCountLabel = [[UILabel alloc] init];
    [personCountLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [personCountLabel setTextColor:[UIColor whiteColor]];
    [personCountLabel setAdjustsFontSizeToFitWidth:YES];
    [self.bContentView addSubview:personCountLabel];
    [personCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeDownView).offset(fScreen(20));
        make.centerY.equalTo(timeDownView);
        make.height.mas_equalTo(fScreen(28));
        make.width.mas_equalTo(fScreen(75));
    }];
    self.groupCountLabel = personCountLabel;
    
    // 规格
    UILabel *specLabel = [[UILabel alloc] init];
    [specLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [specLabel setTextColor:HexColor(0x5560f1)];
    [specLabel setTextAlignment:NSTextAlignmentRight];
    [self.bContentView addSubview:specLabel];
    [specLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bContentView).offset(-fScreen(20));
        make.width.mas_equalTo(fScreen(200));
        make.height.mas_equalTo(fScreen(24));
        make.bottom.equalTo(timeDownView.mas_top).offset(-fScreen(20));
    }];
    self.goodsSpecLabel = specLabel;
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(48)]];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [self.bContentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bContentView).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(48));
        make.right.mas_equalTo(self.goodsSpecLabel.mas_left).offset(-fScreen(20));
        make.baseline.equalTo(self.goodsSpecLabel.mas_baseline);
    }];
    self.priceLabel = priceLabel;
}

- (UILabel *)timeLabel
{
    UILabel *label = [[UILabel alloc] init];
    [label setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4f]];
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setCornerRadius:fScreen(10)];
    [label.layer setMasksToBounds:YES];
    
    return label;
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

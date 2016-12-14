//
//  MineOrderTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/24.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineOrderTabCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "OrderModel.h"

@interface MineOrderTabCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;          // 商品图片
@property (nonatomic, strong) UILabel *goodsNameLabel;              // 商品名称
@property (nonatomic, strong) UILabel *goodsSpecificationLabel;     // 商品规格
@property (nonatomic, strong) UILabel *goodsPriceLabel;             // 商品单价
@property (nonatomic, strong) UILabel *goodsNumberLabel;            // 商品数量
@property (nonatomic, strong) UILabel *limitNumber;                 // 限购数量
@property (nonatomic, strong) UILabel *lookGroupDetail;             // 查看拼团详情
@property (nonatomic, copy) NSString *goodsId;

@end


@implementation MineOrderTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
            
            [self initUI];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    // 图片
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    [goodsImageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(28));
        make.width.mas_equalTo(fScreen(160));
        make.height.mas_equalTo(fScreen(160));
        make.top.equalTo(self.mas_top).offset(fScreen(20));
    }];
    self.goodsImageView = goodsImageView;
    
    // 限购
    UILabel *limitLabel = [[UILabel alloc] init];
    [limitLabel setBackgroundColor:HexColor(0xe44b62)];
    [limitLabel.layer setCornerRadius:fScreen(8)];
    [limitLabel .layer setMasksToBounds:YES];
    [limitLabel setTextColor:[UIColor whiteColor]];
    [limitLabel setTextAlignment:NSTextAlignmentCenter];
    [limitLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [self addSubview:limitLabel];
    [limitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(110));
        make.height.mas_equalTo(fScreen(38));
        make.bottom.mas_equalTo(goodsImageView.mas_bottom);
    }];
    self.limitNumber = limitLabel;
    
    // 规格
    UILabel *specificationLabel = [[UILabel alloc] init];
    [specificationLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [specificationLabel setTextColor:HexColor(0x666666)];
    [self addSubview:specificationLabel];
    [specificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.centerY.equalTo(goodsImageView).offset(fScreen(10));
        make.right.equalTo(self.mas_right);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.goodsSpecificationLabel = specificationLabel;
    
    // 商品名
    UILabel *goodsNameLabel = [[UILabel alloc] init];
    [goodsNameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [goodsNameLabel setNumberOfLines:2];
    [self addSubview:goodsNameLabel];
    [goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(fScreen(340));
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.top.equalTo(goodsImageView.mas_top);
        make.height.mas_equalTo(fScreen(28));
    }];
    self.goodsNameLabel = goodsNameLabel;
    
    // 价格
    UILabel *goodsPriceLabel = [[UILabel alloc] init];
    [goodsPriceLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [goodsPriceLabel setTextColor:HexColor(0x333333)];
    [goodsPriceLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:goodsPriceLabel];
    [goodsPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.top.equalTo(goodsImageView.mas_top);
        make.left.equalTo(goodsNameLabel.mas_right).offset(10);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(32)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.goodsPriceLabel = goodsPriceLabel;
    
    // 数量
    UILabel *goodsNumberLabel = [[UILabel alloc] init];
    [goodsNumberLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [goodsNumberLabel setTextColor:HexColor(0x999999)];
    [goodsNumberLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:goodsNumberLabel];
    [goodsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(goodsPriceLabel.mas_right);
        make.top.equalTo(goodsPriceLabel.mas_bottom).offset(fScreen(14));
        make.left.equalTo(goodsPriceLabel.mas_left);
        CGSize textSize = [@"高度" sizeForFontsize:fScreen(32)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.goodsNumberLabel = goodsNumberLabel;
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(fScreen(10));
    }];
    
    // 查看拼团详情
    UILabel *lookGroupDetail = [[UILabel alloc] init];
    [lookGroupDetail setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [lookGroupDetail setText:@"查看拼团详情"];
    [lookGroupDetail setBackgroundColor:[UIColor whiteColor]];
    [lookGroupDetail setTextColor:HexColor(0x666666)];
    [lookGroupDetail setTextAlignment:NSTextAlignmentCenter];
    [lookGroupDetail.layer setBorderWidth:1.f];
    [lookGroupDetail.layer setBorderColor:HexColor(0x999999).CGColor];
    [lookGroupDetail.layer setCornerRadius:5.f];
    [self addSubview:lookGroupDetail];
    [lookGroupDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(36));
        make.bottom.equalTo(goodsImageView);
        make.width.mas_equalTo([lookGroupDetail.text sizeForFontsize:fScreen(24)].width + fScreen(20));
    }];
    self.lookGroupDetail = lookGroupDetail;
    [lookGroupDetail setHidden:YES];
}

- (void)setOrderModel:(OrderModel *)orderModel
{
    _orderModel = orderModel;
    
    self.goodsId = orderModel.goodsId;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.goodsImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
    
    [self adjustNameLabel:orderModel.goodsName];
    [self.goodsSpecificationLabel setText:orderModel.goodsSpecification];
    
    if (orderModel.goodsLimitNumber > 0) {
        NSString *limitString = [NSString stringWithFormat:@"限购%ld件",orderModel.goodsLimitNumber];
        [self.limitNumber setText:limitString];
        [self.limitNumber setHidden:NO];
    }
    else {
        [self.limitNumber setHidden:YES];
    }
    
    NSString *priceString = [NSString stringWithFormat:@"¥%@",orderModel.goodsPrice];
    [self.goodsPriceLabel setText:priceString];
    
    NSString *numberString = [NSString stringWithFormat:@"x%ld",orderModel.goodsNumber];
    [self.goodsNumberLabel setText:numberString];
    
    [self.lookGroupDetail setHidden:orderModel.isGroup ? NO : YES];
}

- (void)adjustNameLabel:(NSString *)text
{
    [self.goodsNameLabel setText:text];
    
    CGFloat labelWidth = fScreen(338);
    
    CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
    CGSize textSize = [self.goodsNameLabel.text boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.goodsNameLabel.font} context:nil].size;
    
    [self.goodsNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textSize.height > fScreen(70) ? fScreen(70) : textSize.height);
    }];
}

@end

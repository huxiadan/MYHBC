//
//  CollShopCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CollShopCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface CollShopCell ()

@property (nonatomic, strong) UIImageView *shopImageView;
@property (nonatomic, strong) UILabel *shopNameLabel;
@property (nonatomic, strong) UIImageView *shopIconImageView;
@property (nonatomic, strong) UIButton *collectButton;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation CollShopCell

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
    // 图片
    UIImageView *shopImageView = [[UIImageView alloc] init];
    [shopImageView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:shopImageView];
    [shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(20));
        make.top.equalTo(self.mas_top).offset(fScreen(30));
        make.bottom.equalTo(self.mas_bottom).offset(-fScreen(30));
        make.width.mas_equalTo(fScreen(168 - 30*2));
    }];
    self.shopImageView = shopImageView;
    
    
    // 分享
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"button_share_n-"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"button_share_h"] forState:UIControlStateHighlighted];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(fScreen(-30));
        make.centerY.equalTo(self.mas_centerY);
        make.width.mas_equalTo(fScreen(40 + 20*2));
        make.height.mas_equalTo(fScreen(40 + 20*2));
    }];
    self.shareButton = shareButton;
    
    // 收藏
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
    self.collectButton = collButton;
    collButton.selected = YES;
    
    // 店铺名
    UILabel *shopNameLabel = [[UILabel alloc] init];
    [shopNameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [shopNameLabel setTextColor:HexColor(0x333333)];
    [self addSubview:shopNameLabel];
    [shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(shopImageView.mas_top);
        make.left.equalTo(shopImageView.mas_right).offset(fScreen(30));
        make.right.equalTo(collButton.mas_right).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(28));
    }];
    self.shopNameLabel = shopNameLabel;
    
    UIImageView *shopIcon = [[UIImageView alloc] init];
    [self addSubview:shopIcon];
    [shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shopNameLabel.mas_left);
        make.top.equalTo(shopNameLabel.mas_bottom).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(90));
        make.height.mas_equalTo(fScreen(30));
    }];
    self.shopIconImageView = shopIcon;
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (void)setModel:(CollShopModel *)model
{
    _model = model;
    
    [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.shopImageURL] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    [self.shopNameLabel setText:model.shopName];
    
    NSString *iconName;
    switch (model.iconType) {
        case ShopIconType_None:
        default:
            iconName = @"";
            break;
        case ShopIconType_Brand:        // 品牌
            iconName = @"lab_brand";
            break;
        case ShopIconType_Official:     // 旗舰
            iconName = @"lab_offic";
            break;
        case ShopIconType_Personal:     // 个人
            iconName = @"lab_gr";
            break;
        case ShopIconType_Company:      // 企业
            iconName = @"lab_qiye";
            break;
    }
    [self.shopIconImageView setImage:[UIImage imageNamed:iconName]];
}

#pragma mark - button click
- (void)shareButtonClick:(UIButton *)sender
{
    if (self.shareBlock) {
        self.shareBlock(self.model.shareModel);
    }
}

- (void)collectionButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (self.collectBlock) {
        self.collectBlock(sender.isSelected);
    }
}

@end

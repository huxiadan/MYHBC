//
//  BaiXianBaiPinBaseTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BaiXianBaiPinBaseTabCell.h"

@implementation BaiXianBaiPinBaseTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initBaseUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initBaseUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    UIView *contentView = [[UIView alloc] init];
    [self addSubview:contentView];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(fScreen(20));
        make.right.equalTo(self).offset(-fScreen(20));
        make.bottom.equalTo(self).offset(-fScreen(20));
    }];
    self.bContentView = contentView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setBackgroundColor:[UIColor redColor]];
    [self.bContentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.bContentView);
        make.width.mas_equalTo(fScreen(280));
    }];
    self.goodsImageView = imageView;
}

@end

//
//  GroupbuyBaseTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyBaseTabCell.h"

@implementation GroupbuyBaseTabCell

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
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(20));
        make.right.equalTo(self).offset(-fScreen(20));
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-fScreen(20));
    }];
    self.bContentView = contentView;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.bContentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bContentView);
        make.height.mas_equalTo(fScreen(358));
    }];
    self.goodsImageView = imageView;
}

@end

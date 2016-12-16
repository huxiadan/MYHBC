//
//  ReviewsCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ReviewsCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "HDTextView.h"
#import "ReviewsPhotosView.h"
#import "HDStarView.h"

@interface ReviewsCell ()

@property (nonatomic, strong) HDTextView *textView;                 // 评价输入
@property (nonatomic, strong) ReviewsPhotosView *photosView;        // 图片的视图
@property (nonatomic, strong) UIView *starContentView;              // 星星视图的父视图
@property (nonatomic, strong) HDStarView *starView;                 // 星星的视图

@end

@implementation ReviewsCell

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
    // 关闭选中高亮
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    // 商品图片
    UIImageView *goodsImageView = [[UIImageView alloc] init];
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
    [self addSubview:goodsImageView];
    [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(28));
        make.top.equalTo(self).offset(fScreen(20));
        make.height.width.mas_equalTo(fScreen(140));
    }];
    
    // 评价
    HDTextView *textView = [[HDTextView alloc] init];
    [textView setPlaceholder:@"请输您入对商品的评价~"];
    [textView setLineSpace:fScreen(10)];
    [textView setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [textView setTextColor:HexColor(0x666666)];
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
        make.right.equalTo(self).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(140));
        make.top.equalTo(goodsImageView);
    }];
    self.textView = textView;
    
    
    // 图片
    ReviewsPhotosView *photoView = [[ReviewsPhotosView alloc] init];
    [self addSubview:photoView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(textView.mas_bottom).offset(fScreen(100 - 18 - 20));
        make.height.mas_equalTo(fScreen(140 + 18 + 20));
    }];
    self.photosView = photoView;
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:HexColor(0xdadada)];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(28));
        make.right.equalTo(self);
        make.height.mas_equalTo(fScreen(2));
        make.top.equalTo(photoView.mas_bottom).offset(fScreen(50));
    }];
    
    // 星星
    UIView *starContentView = [[UIView alloc] init];
    [starContentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:starContentView];
    [starContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-fScreen(20));
        make.top.equalTo(line.mas_bottom);
    }];
    
    UILabel *starLabel = [[UILabel alloc] init];
    [starLabel setFont:[UIFont systemFontOfSize:fScreen(30)]];
    [starLabel setText:@"商品评价"];
    [starLabel setTextColor:HexColor(0x333333)];
    [starContentView addSubview:starLabel];
    [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(starContentView).offset(fScreen(28));
        make.centerY.equalTo(starContentView);
        make.height.mas_equalTo(fScreen(30));
        make.width.mas_equalTo(fScreen(200));
    }];
    
    HDStarView *starView = [[HDStarView alloc] initWithStarNumber:5 height:fScreen(45) margin:fScreen(26)];
    [starContentView addSubview:starView];
    [starView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(starContentView).offset(-fScreen(30));
        make.centerY.equalTo(starLabel);
        make.height.mas_equalTo(fScreen(45));
        make.width.mas_equalTo(fScreen(45*5 + 26*4));
    }];
    
    UIView *bottomLine = [[UIView alloc] init];
    [bottomLine setBackgroundColor:viewControllerBgColor];
    [self addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(fScreen(20));
    }];
}

- (void)setNavController:(UINavigationController *)navController
{
    _navController = navController;
    
    self.photosView.navController = navController;
}

@end

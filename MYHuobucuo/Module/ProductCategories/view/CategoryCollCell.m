//
//  CategoryCollCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryCollCell.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface CategoryCollCell ()

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *goodsNameLabel;

@end

@implementation CategoryCollCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor redColor]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.height.mas_equalTo(fScreen(152));
            make.width.mas_equalTo(fScreen(152));
            make.top.equalTo(self.mas_top);
        }];
        self.goodsImageView = imageView;
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [nameLabel setTextColor:HexColor(0x666666)];
        [nameLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).offset(-fScreen(16));
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(24)];
            make.height.mas_equalTo(textSize.height);
        }];
        self.goodsNameLabel = nameLabel;
        
    }
    return self;
}

- (void)setModel:(CategoryDetailModel *)model
{
    _model = model;
    
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.categoryImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
    [self.goodsNameLabel setText:model.categoryName];
}

@end

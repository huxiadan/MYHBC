//
//  CategoryHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryHeaderView.h"
#import <Masonry.h>

@interface CategoryHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *lineLeftView;
@property (nonatomic, strong) UIView *lineRightView;

@end

@implementation CategoryHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel = [[UILabel alloc] init];
        [self.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [self.titleLabel setTextColor:HexColor(0x333333)];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
            make.width.mas_equalTo(fScreen(textSize.width + 2));
            make.height.mas_equalTo(fScreen(textSize.height));
        }];
        
        UIView *leftView = [[UIView alloc] init];
        [leftView setBackgroundColor:HexColor(0xdadada)];
        [self addSubview:leftView];
        [leftView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fScreen(18));
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.titleLabel.mas_left).offset(-fScreen(30));
            make.height.equalTo(@1);
        }];
        self.lineLeftView = leftView;
        
        
        UIView *rightView = [[UIView alloc] init];
        [rightView setBackgroundColor:leftView.backgroundColor];
        [self addSubview:rightView];
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-fScreen(18));
            make.height.equalTo(@1);
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.titleLabel.mas_right).offset(fScreen(30));
        }];
        self.lineRightView = rightView;
    }
    return self;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = [titleText copy];
    
    [self.titleLabel setText:titleText];
    CGSize textSize = [titleText sizeForFontsize:fScreen(28)];
    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(textSize.width + 2);
        make.height.mas_equalTo(fScreen(28));
    }];
    
    [self.lineLeftView layoutIfNeeded];
    [self.lineRightView layoutIfNeeded];
    
}

@end

//
//  MainModelCollHeader.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/10.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MainModelCollHeader.h"
#import <Masonry.h>

@interface MainModelCollHeader ()

@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UILabel *mainTitleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *pointView;

@end

@implementation MainModelCollHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:viewControllerBgColor];
        
        UIView *labelView = [[UILabel alloc] init];
        [labelView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:labelView];
        [labelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_top).offset(fScreen(20));
            make.bottom.equalTo(self.mas_bottom).offset(-fScreen(20));
        }];
        self.labelView = labelView;
        
        UILabel *mainLabel = [[UILabel alloc] init];
        [mainLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [mainLabel setTextColor:HexColor(0x333333)];
        [self addSubview:mainLabel];
        [mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(labelView.mas_left);
            make.centerY.equalTo(labelView.mas_centerY);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(28)];
            make.height.mas_equalTo(textSize.height);
            make.width.mas_equalTo(textSize.width);
        }];
        
        self.mainTitleLabel = mainLabel;
        
        UIView *pointView = [[UIView alloc] init];
        [pointView setBackgroundColor:HexColor(0xe77bf0)];
        [pointView.layer setCornerRadius:fScreen(4)];
        [pointView.layer setMasksToBounds:YES];
        [self addSubview:pointView];
        [pointView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(fScreen(8));
            make.height.mas_equalTo(fScreen(8));
            make.left.equalTo(mainLabel.mas_right).offset(fScreen(12));
        }];
        self.pointView = pointView;
        
        UILabel *subLabel = [[UILabel alloc] init];
        [subLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [subLabel setTextColor:HexColor(0x999999)];
        [self addSubview:subLabel];
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(pointView.mas_right).offset(fScreen(12));
            make.right.equalTo(self.mas_right).offset(-fScreen(20));
            make.top.bottom.equalTo(mainLabel);
        }];
        self.subTitleLabel = subLabel;
    }
    return self;
}

- (void)setModel:(MainModelHeaderModel *)model
{
    _model = model;
    
    [self.mainTitleLabel setText:model.mainTitle];
    [self.subTitleLabel setText:model.subTitle];
    
    CGSize mainSize = [model.mainTitle sizeForFontsize:fScreen(28)];
    CGSize subSize = [model.subTitle sizeForFontsize:fScreen(28)];
    CGFloat width = (mainSize.width + 2) + (subSize.width + 2) + (fScreen(12 + 8 + 12));
    CGFloat leftMargin = (kAppWidth - width)/2;
    [self.mainTitleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.labelView.mas_left).offset(leftMargin);
        make.width.mas_equalTo(mainSize.width + 2);
    }];
    
    [self.mainTitleLabel layoutIfNeeded];
    [self.pointView layoutIfNeeded];
    [self.subTitleLabel layoutIfNeeded];
}

@end

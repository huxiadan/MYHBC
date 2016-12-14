//
//  CategoryDockCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryDockCell.h"
#import <Masonry.h>

@interface CategoryDockCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation CategoryDockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIView *selectLineView = [[UIView alloc] init];
    [selectLineView setBackgroundColor:HexColor(0xe44a62)];
    [self addSubview:selectLineView];
    [selectLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(fScreen(6));
    }];
    self.selectLineView = selectLineView;
    [selectLineView setHidden:YES];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x333333)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self);
    }];
    self.titleLabel = titleLabel;
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [self setBackgroundColor:selected ? viewControllerBgColor : [UIColor whiteColor]];
    [self.selectLineView setHidden:!selected];
}

- (void)setModel:(CategoryDockModel *)model
{
    [self.titleLabel setText:model.categoryName];
}

@end

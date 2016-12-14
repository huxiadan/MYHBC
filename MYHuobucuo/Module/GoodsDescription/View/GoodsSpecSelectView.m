//
//  GoodsSpecSelectView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/18.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsSpecSelectView.h"
#import <Masonry.h>

@interface GoodsSpecSelectView ()

@property (nonatomic, strong) NSArray *specArray;   // 元素为字典, key: 规格的分类 value: 具体分类规格的子项

@property (nonatomic, strong) UIImageView *goodsImageView;
@property (nonatomic, strong) UILabel *priceLabel;          // 价格
@property (nonatomic, strong) UILabel *storeLabel;          // 库存
@property (nonatomic, strong) UILabel *selectLable;         // 选择结果
@property (nonatomic, strong) UIScrollView *allSpecView;    // 选项
@property (nonatomic, strong) UIButton *sureButton;         // 确认按钮

@end

@implementation GoodsSpecSelectView

- (instancetype)initWithSpecArray:(NSArray *)specArray
{
    if (self = [super init]) {
        
        self.specArray = specArray;
        
        [self initUI];
        
        [self setUIValue];
    }
    return self;
}

- (void)initUI
{
    [self setFrame:[UIScreen mainScreen].bounds];
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4f]];
    self.alpha = 0;
    self.hidden = YES;
    
    
    UIView *contentView = [self makeContentView];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(self.mas_top).offset(fScreen(414));
    }];
    
    UIButton *hideButton = [[UIButton alloc] init];
    [hideButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:hideButton];
    [hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.bottom.equalTo(contentView.mas_top);
    }];
    
    // 图片
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setBorderWidth:1.5f];
    [imageView.layer setCornerRadius:fScreen(10)];
    [imageView.layer setMasksToBounds:YES];
    [imageView setImage:[UIImage imageNamed:@"placeholder.JPG"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(fScreen(382));
        make.left.equalTo(self).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(254));
        make.height.mas_equalTo(fScreen(254));
    }];
}

- (UIView *)makeContentView
{
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    
    // 价格
    UILabel *priceLabel = [[UILabel alloc] init];
    [priceLabel setFont:[UIFont systemFontOfSize:fScreen(34)]];
    [priceLabel setTextColor:HexColor(0xe44a62)];
    [contentView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(fScreen(20 + 254 + 24));
        make.top.equalTo(contentView).offset(fScreen(40));
        make.right.equalTo(contentView).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(34));
    }];
    self.priceLabel = priceLabel;
    [priceLabel setText:@"￥99-19999"];
    
    // 库存
    UILabel *storeLabel = [[UILabel alloc] init];
    [storeLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [storeLabel setTextColor:HexColor(0x333333)];
    [contentView addSubview:storeLabel];
    [storeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(priceLabel);
        make.top.equalTo(priceLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(28));
    }];
    self.storeLabel = storeLabel;
    [storeLabel setText:@"库存8888件"];
    
    // 选择的规格
    UILabel *selectLabel = [[UILabel alloc] init];
    [selectLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [selectLabel setTextColor:HexColor(0x333333)];
    [contentView addSubview:selectLabel];
    [selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(priceLabel);
        make.top.equalTo(storeLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(28));
    }];
    self.selectLable = selectLabel;
    
    // 确定按钮
    UIButton *sureButton = [[UIButton alloc] init];
    [sureButton setBackgroundColor:RGB(228, 75, 98)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(contentView);
        make.height.mas_equalTo(fScreen(88));
    }];
    self.sureButton = sureButton;
    
    // 规格列表
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    [contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(contentView).offset(fScreen(220 + 20));
        make.bottom.equalTo(sureButton.mas_top).offset(-fScreen(20));
    }];
    
    self.allSpecView = scrollView;
    
    return contentView;
}

// 设置 UI 的值
- (void)setUIValue
{
    CGFloat y = fScreen(10);
    NSMutableString *selectInitText = [NSMutableString stringWithString:@"请选择 "];
    
    NSInteger arrCount = self.specArray.count;
    for (NSInteger index = 0; index < arrCount ; index++) {
        NSDictionary *dict = (NSDictionary *)[self.specArray objectAtIndex:index];
        
        NSString *titleText = dict.allKeys[0];
        [selectInitText appendString:[NSString stringWithFormat:@"%@ ", titleText]];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [titleLabel setTextColor:HexColor(0x333333)];
        [titleLabel setText:titleText];
        CGSize titleSize = [titleText sizeForFontsize:fScreen(28)];
        CGRect titleFrame = CGRectMake(fScreen(30), y, titleSize.width + 2, fScreen(28));
        [titleLabel setFrame:titleFrame];
        [self.allSpecView addSubview:titleLabel];
        
        y += fScreen(28 + 30);
        CGFloat x = fScreen(30);
        
        NSArray *options = (NSArray *)dict[titleText];
        for (NSString *text in options) {
            CGSize textSize = [text sizeForFontsize:fScreen(24)];
            UIButton *button = [self makeButton];
            [button setTitle:text forState:UIControlStateNormal];
            
            CGFloat buttonWidth = textSize.width + fScreen(22*2);
            [button setFrame:CGRectMake(x, y, buttonWidth, fScreen(64))];
            [self.allSpecView addSubview:button];
            
            x += buttonWidth + fScreen(26);
            if (x > kAppWidth) {
                x = fScreen(30);
                y += fScreen(64 + 30);
                [button setFrame:CGRectMake(x, y, buttonWidth, fScreen(64))];
            }
        }
        
        if (index < arrCount - 1) {
            y += fScreen(30 + 64);
            UIView *lineView = [[UIView alloc] init];
            [lineView setBackgroundColor:viewControllerBgColor];
            [lineView setFrame:CGRectMake(fScreen(34), y , kAppWidth - fScreen(34*2), 1)];
            [self.allSpecView addSubview:lineView];
            
            y += fScreen(30);
        }
    }
    [self.allSpecView setContentSize:CGSizeMake(0, y + fScreen(64 + 30))];
    
    [self.selectLable setText:selectInitText];
}

- (UIButton *)makeButton
{
    UIButton *button = [[UIButton alloc] init];
    [button setBackgroundColor:RGB(245, 245, 245)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [button setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [button setTitleColor:HexColor(0x333333) forState:UIControlStateSelected];
    [button.layer setCornerRadius:fScreen(20)];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)sureButtonClick:(UIButton *)sender
{
    if (self.selectSpecBlock) {
        self.selectSpecBlock(@[]);
    }
}

- (void)buttonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

- (void)hideView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)showView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.hidden = NO;
        self.alpha = 1;
    }];
}

@end

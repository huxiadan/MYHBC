//
//  StoreItemButton.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/30.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreItemButton.h"
#import <Masonry.h>

@interface StoreItemButton ()

@property (nonatomic, strong) UIImage *normalImage;         // 普通图片
@property (nonatomic, strong) UIImage *heightlightImage;    // 高亮图片

@property (nonatomic, strong) UIColor *normalTitleColor;
@property (nonatomic, strong) UIColor *heightlightColor;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) CGFloat height;

@end

@implementation StoreItemButton

- (instancetype)initWithTitle:(NSString *)title
                    imageName:(NSString *)imageName
         heightlightImageName:(NSString *)heightlightImageName
                       target:(id)target
                       action:(SEL)action
{
    if (self = [super init]) {
        self.normalImage      = [UIImage imageNamed:imageName];
        self.heightlightImage = [UIImage imageNamed:heightlightImageName];
        
        self.normalTitleColor = HexColor(0x999999);
        self.heightlightColor = HexColor(0xe44a62);
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setImage:self.normalImage];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self);
            make.width.mas_equalTo(self.normalImage.size.width);
            make.height.mas_equalTo(self.normalImage.size.height);
        }];
        self.imageView = imageView;
        
        self.height += self.normalImage.size.height;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [titleLabel setTextColor:self.normalTitleColor];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setText:title];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(fScreen(24));
            make.left.right.equalTo(self);
            make.height.mas_equalTo(fScreen(28));
        }];
        self.titleLabel = titleLabel;
        
        self.height += fScreen(24 + 28);
        
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.equalTo(self);
        }];
        self.button = button;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    if (selected) {
        [self.imageView setImage:self.heightlightImage];
        [self.titleLabel setTextColor:self.heightlightColor];
    }
    else {
        [self.imageView setImage:self.normalImage];
        [self.titleLabel setTextColor:self.normalTitleColor];
    }
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    
    self.button.tag = tag;
}

@end

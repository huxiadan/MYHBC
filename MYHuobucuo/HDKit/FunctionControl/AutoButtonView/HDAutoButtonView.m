//
//  HDAutoButtonView.m
//  MYHuobucuo
//
//  Created by hudan on 16/9/27.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDAutoButtonView.h"

typedef void(^ClickBlock)(NSString *title);

@interface HDAutoButtonView ()

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *titleColorHeightlight;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat corner;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat buttonMargin;

@property (nonatomic, strong) NSArray *heightlightTitles;

@property (nonatomic, copy) ClickBlock clickBlock;

@end

@implementation HDAutoButtonView

- (instancetype)initWithFrame:(CGRect)frame
                 buttonTitles:(NSArray *)titles
            buttonTitleHeight:(NSArray *)heightlightTitles
          attributeDictionary:(NSDictionary *)attribute
                   clickBlock:(void(^)(NSString *))clickBlock
{
    if (self = [super initWithFrame:frame]) {
        
        [self setPropertyWithDict:attribute];
        
        self.clickBlock = clickBlock;
        self.heightlightTitles = heightlightTitles;
        
        CGFloat x = self.buttonMargin;
        CGFloat y = self.buttonMargin;
        
        for (NSString *title in titles) {
            
            UIButton *button = [self createButtonWithTitle:title];
            
            CGRect buttonFrame = button.frame;
            
            if (x + buttonFrame.size.width - self.buttonMargin > self.frame.size.width) {
                // 换行
                y += buttonFrame.size.height + self.buttonMargin;
                x = self.buttonMargin;
            }
            
            buttonFrame.origin.x = x;
            buttonFrame.origin.y = y;
            
            [button setFrame:buttonFrame];
            
            [self addSubview:button];
            
            x += buttonFrame.size.width + self.buttonMargin;
        }
    }
    return self;
}

// 创建 button
- (UIButton *)createButtonWithTitle:(NSString *)title
{
    UIButton *button = [[UIButton alloc] init];
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:self.fontSize]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:self.titleColor forState:UIControlStateNormal];
    [button.layer setBorderWidth:1.f];
    [button.layer setBorderColor:self.borderColor.CGColor];
    [button.layer setCornerRadius:self.corner];
    // 设置突出文字
    if ([self.heightlightTitles containsObject:title]) {
        [button setTitleColor:self.titleColorHeightlight forState:UIControlStateNormal];
    }
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize textSize = [title sizeForFontsize:15.f];
    [button setFrame:CGRectMake(0, 0, textSize.width + 6, textSize.height + 4)];
    
    return button;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.clickBlock) {
        self.clickBlock(sender.titleLabel.text);
    }
}

// 设置属性
- (void)setPropertyWithDict:(NSDictionary *)attribute
{
    if ((self.fontSize = [[attribute objectForKey:HDAutoButtonViewFontSizeKey] floatValue]) == 0) {
        self.fontSize = 15.f;
    }
    if (!(self.titleColor = [attribute objectForKey:HDAutoButtonViewTitleColorKey])) {
        self.titleColor = [UIColor blackColor];
    }
    if (!(self.titleColorHeightlight = [attribute objectForKey:HDAutoButtonViewTitleColorHeightLightKey])) {
        self.titleColorHeightlight = [UIColor blackColor];
    }
    if ((self.corner = [[attribute objectForKey:HDAutoButtonViewCornerKey] floatValue]) == 0) {
        self.corner = 10.f;
    }
    if ((self.buttonMargin = [[attribute objectForKey:HDAutoButtonViewButtonMarginKey] floatValue]) == 0) {
        self.buttonMargin = 10.f;
    }
    if (!(self.borderColor = [attribute objectForKey:HDAutoButtonViewBorderColorKey])) {
        self.borderColor = [UIColor blackColor];
    }
}


@end

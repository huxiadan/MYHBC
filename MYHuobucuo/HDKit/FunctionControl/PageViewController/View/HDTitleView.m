//
//  HDTitleView.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "HDTitleView.h"

#import "NSString+HD.h"

#define kTitleButtonMargin   10
//#define kTitleButtonFontSize 16.f

@interface HDTitleView ()

@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSArray *buttonArray;

@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *currButton;

@property (nonatomic, assign) CGFloat buttonMargin;
@property (nonatomic, assign) CGFloat firstButtonMargin;
@property (nonatomic, assign) CGFloat fontSize;

@end

@implementation HDTitleView

- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titlesArray
                 buttonMargin:(CGFloat)buttonMargin
            firstButtonMargin:(CGFloat)firstMargin
                     fontSize:(CGFloat)fontSize
{
    if (self = [super initWithFrame:frame]) {
        self.titlesArray = titlesArray;
        self.buttonMargin = buttonMargin;
        self.firstButtonMargin = firstMargin;
        self.fontSize = fontSize;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    self.isShowBottomLine = YES;
    
    self.layer.masksToBounds = YES;
    self.showsHorizontalScrollIndicator = NO;
    
    // 将每个title添加入view
    CGFloat x = self.firstButtonMargin;
    NSInteger index = 0;
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:self.titlesArray.count];
    
    if ([self.titlesArray count] > 0) {
        for (NSString *title in self.titlesArray) {
            UIButton *button = [self createButton];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize size = [title sizeForFontsize:self.fontSize];
            [button setTitle:title forState:UIControlStateNormal];
            [button setFrame:CGRectMake(x,
                                        (self.frame.size.height - size.height)/2,
                                        size.width , size.height)];
            
            button.tag     = index;
            
            [tempArray addObject:button];
            [self addSubview:button];
            
            x += size.width + self.buttonMargin;
            
            if (index == 0) {
                self.currButton = button;
                
                // 创建bottomLine
                self.bottomLine = [[UIView alloc] init];
                if (self.bottomLineColor) {
                    [self.bottomLine setBackgroundColor:self.bottomLineColor];
                }
                else {
                    [self.bottomLine setBackgroundColor:[UIColor redColor]];
                }
                CGRect bottomFrame = button.frame;
                bottomFrame.origin.x -= fScreen(16);
                bottomFrame.origin.y = self.frame.size.height - 1;
                bottomFrame.size.height = 1;
                bottomFrame.size.width += fScreen(16)*2;
                [self.bottomLine setFrame:bottomFrame];
                
                [self addSubview:self.bottomLine];
            }
            
            index++;
        }
    }
    
    self.buttonArray = [tempArray copy];
    [self setContentSize:CGSizeMake(x - (self.buttonMargin - self.firstButtonMargin), 0)];
}

- (UIButton *)createButton
{
    UIButton *button = [[UIButton alloc] init];
    [button.titleLabel setFont:[UIFont systemFontOfSize:self.fontSize]];
    if (self.normalButtonColor) {
        [button setTitleColor:self.normalButtonColor forState:UIControlStateNormal];
    }
    else {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return button;
}

- (void)buttonClick:(UIButton *)sender
{
    if ([self.currButton isEqual:sender]) {
        return;
    }
    
    [self moveToButton:sender];
}

- (void)moveToButtonWithIndex:(NSInteger)buttonIndex
{
    UIButton *button = [self.buttonArray objectAtIndex:buttonIndex];
    
    [self moveToButton:button];
}

- (void)moveToButton:(UIButton *)button
{
    CGRect frame = button.frame;
    CGFloat appWidth = kAppWidth;
    
    CGPoint offset = self.contentOffset;
    
    if (frame.origin.x + frame.size.width/2 < appWidth/2) {
        // 最左边的几个不需要移动的按钮
        offset = CGPointZero;
    }
    else if (self.contentSize.width <= appWidth)
    {
        // 这种情况任何 title 都不需要移动
    }
    else if (self.contentSize.width - frame.origin.x < appWidth/2 || self.contentSize.width - frame.origin.x - frame.size.width/2 <= appWidth/2) {
        // 最右边的几个不需要移动的按钮
        offset = CGPointMake(self.contentSize.width - appWidth, 0);
    }
    else {
        // 其他可以移动的按钮
        offset = CGPointMake(frame.origin.x + frame.size.width/2 - appWidth/2, 0);
    }
    
    if (self.normalButtonColor) {
        [self.currButton setTitleColor:self.normalButtonColor forState:UIControlStateNormal];
    }
    else {
        [self.currButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    CGRect bottomFrame = self.bottomLine.frame;
    bottomFrame.origin.x = CGRectGetMinX(button.frame) - fScreen(16);
    bottomFrame.size.width = CGRectGetWidth(button.frame) + fScreen(16)*2;
    
    
    [UIView animateWithDuration:0.3f animations:^{
        self.currButton = button;
        self.contentOffset = offset;
        
        [self.bottomLine setFrame:bottomFrame];
    }];
    
    // block
    if (self.buttonClickBlock) {
        self.buttonClickBlock(button.tag);
    }
}

- (void)setCurrButton:(UIButton *)currButton
{
    if (self.selectButtonColor) {
        [currButton setTitleColor:self.selectButtonColor forState:UIControlStateNormal];
    }
    else {
        [currButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    _currButton = currButton;
}

#pragma mark - Setter
- (void)setSelectButtonColor:(UIColor *)selectButtonColor
{
    _selectButtonColor = selectButtonColor;
    
    if ([self.buttonArray count] > 0) {
        for (UIButton *button in self.buttonArray) {
            if ([button isEqual:self.currButton]) {
                [button setTitleColor:_selectButtonColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setNormalButtonColor:(UIColor *)normalButtonColor
{
    _normalButtonColor = normalButtonColor;
    
    if ([self.buttonArray count] > 0) {
        for (UIButton *button in self.buttonArray) {
            if (![button isEqual:self.currButton]) {
                [button setTitleColor:_normalButtonColor forState:UIControlStateNormal];
            }
        }
    }
}

- (void)setBottomLineColor:(UIColor *)bottomLineColor
{
    _bottomLineColor = bottomLineColor;
    
    [self.bottomLine setBackgroundColor:_bottomLineColor];
}

- (void)setIsShowBottomLine:(BOOL)isShowBottomLine
{
    _isShowBottomLine = isShowBottomLine;
    
    [self.bottomLine setHidden:!isShowBottomLine];
}

@end

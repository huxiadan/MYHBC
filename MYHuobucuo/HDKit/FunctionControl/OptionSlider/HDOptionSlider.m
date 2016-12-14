//
//  HDOptionSlider.m
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDOptionSlider.h"

#import <Masonry.h>

typedef NS_ENUM(NSInteger, OptionSliderType)
{
    optionSliderTypeAutoButtonWidth  = 0,     // 按钮宽度适应文字
    optionSliderTypeConstButtonWidth = 1      // 按钮宽度为固定值
};

@interface HDOptionSlider()
{
    NSInteger contentViewWidth;
}

@property (nonatomic, retain) NSArray *buttonsCenterXArray;     // 存放每个button的中心相对contentView的x坐标
@property (nonatomic, retain) NSArray *allButtonArray;          // 存放所有按钮对象

@property (nonatomic, strong) UIButton *selectedButton;         // 当前选中的button
@property (nonatomic, strong) UIView *contentView;              // 存放buttons的UIView
@property (nonatomic, strong) UIView *pointView;                // 圆点

@property (nonatomic, assign) OptionSliderType sliderType;      // 控件的类型(宽度固定和宽度不固定)
@property (nonatomic, assign) NSInteger constButtonWidth;       // 固定宽度的按钮宽度

@property (nonatomic, retain) NSArray *buttonsLeftMarginArray;  // 存放每个按钮相对contentView视图的左边距
@property (nonatomic, retain) NSArray *buttonsWidthArray;       // 每个按钮的宽度

@end

@implementation HDOptionSlider

#pragma mark -Init
- (instancetype)initWithAutoButtonWithTitles:(NSArray *)titles
{
    if (self = [self init]) {
        
        self.sliderType = optionSliderTypeAutoButtonWidth;
        
        self.titlesArray = titles;
    }
    
    return self;
}

- (instancetype)initWithConstantButtonWithTitles:(NSArray *)titles withButtonWidth:(NSInteger)buttonWidth
{
    if (self = [self init]) {
        
        self.sliderType = optionSliderTypeConstButtonWidth;
        
        self.constButtonWidth = buttonWidth;
        
        self.titlesArray = titles;
    }
    
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupUI];
        
        self.defaultIndex =-1;
    }
    
    return self;
}

#pragma mark -UI设置
- (void)setupUI
{
    self.backgroundColor = [UIColor clearColor];
    //debug
    //    self.backgroundColor = [UIColor greenColor];
    self.layer.masksToBounds = YES;
    
    // 添加小圆形
    [self addCircleView];
    
    // 添加手势
    [self addSwipeGesture];
}

// 添加底部圆圈
- (void)addCircleView
{
    if (_pointView) {
        [_pointView removeFromSuperview];
    }
    
    UIView *circleView = [[UIView alloc] init];
    
    if (!self.pointColor) {
        self.pointColor = [UIColor redColor];
    }
    circleView.backgroundColor = self.pointColor;
    
    if (0 == self.pointRadius) {
        self.pointRadius = 3;
    }
    
    float radius = self.pointRadius;
    circleView.layer.cornerRadius = radius;
    circleView.layer.masksToBounds = YES;
    
    [self addSubview:circleView];
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.width.height.mas_equalTo(radius * 2);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    _pointView = circleView;
}

/**
 *  将每个选项添加入视图
 *
 *  @param titles 包含所有选项显示名称的数组
 */
- (void)addAutoButton:(NSArray *)titles
{
    if (!titles || 0 == titles.count) {
        return;
    }
    
    if (0 == _optionMargin) {
        _optionMargin = 10;
    }
    
    NSInteger arrayCount = titles.count;
    // 数组存放给个按钮的宽度
    NSMutableArray *buttonsWidth = [NSMutableArray arrayWithCapacity:arrayCount];
    // 数组存放每个按钮的中心相对view左边距离
    NSMutableArray *buttonsLeftOffset = [NSMutableArray arrayWithCapacity:arrayCount];
    // 数组存放所有的按钮
    NSMutableArray *mAllButtonArray = [NSMutableArray arrayWithCapacity:arrayCount];
    
    // 存放当前插入的按钮距离父视图左边距
    NSInteger maxLeftOffset = 0;
    
    // 按钮标示，也是之后的索引值
    NSInteger btnTag = 0;
    
    // contentView
    if (self.contentView) {
        [self.contentView removeFromSuperview];
    }
    UIView *contentView = [[UIView alloc] init];
    
    for (NSString *title in titles) {
        
        // 计算按钮的宽度
        CGFloat titlesLength = 0;
        if (optionSliderTypeAutoButtonWidth == self.sliderType) {
            titlesLength = [self sizeForTitle:title];
        }
        else if (optionSliderTypeConstButtonWidth == self.sliderType) {
            titlesLength = self.constButtonWidth;
        }
        
        [buttonsWidth addObject:[NSNumber numberWithFloat:titlesLength]];
        
        [buttonsLeftOffset addObject:[NSNumber numberWithFloat:maxLeftOffset]];
        
        // 添加按钮
        UIButton *optionButton = [[UIButton alloc] init];
        
        //debug
        //        optionButton.backgroundColor = [UIColor yellowColor];
        
        // 字体颜色
        if (!self.normalColor) {
            _normalColor = [UIColor grayColor];
        }
        [optionButton setTitleColor:self.normalColor forState:UIControlStateNormal];
        if (!self.selectedColor) {
            _selectedColor = [UIColor blueColor];
        }
        [optionButton setTitleColor:self.selectedColor forState:UIControlStateSelected];
        // 字体大小
        if (0 != self.fontSize) {
            optionButton.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
        }
        
        [optionButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [optionButton setTitle:title forState:UIControlStateNormal];
        
        [optionButton setTag:btnTag];
        
        btnTag++;
        
        // 设置按钮的布局
        [contentView addSubview:optionButton];
        
        [optionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView.mas_left).offset(maxLeftOffset);
            make.width.mas_equalTo(titlesLength);
            make.top.bottom.equalTo(contentView);
        }];
        
        // button添加入allButtonArray
        [mAllButtonArray addObject:optionButton];
        
        // 添加完按钮后再计算
        if (0 == self.optionMargin) {
            self.optionMargin = 10;
        }
        maxLeftOffset += titlesLength + self.optionMargin;
    }
    
    self.buttonsLeftMarginArray = buttonsLeftOffset;
    self.buttonsWidthArray = buttonsWidth;
    self.allButtonArray = mAllButtonArray;
    
    [self addSubview:contentView];
    self.contentView = contentView;
    
    contentViewWidth = maxLeftOffset - _optionMargin;
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-(self.pointRadius * 2));
        make.width.mas_equalTo(contentViewWidth);
    }];
    
    if (0 < self.defaultIndex) {
        [self moveToButton:self.defaultIndex];
    }
    else {
        [self moveToButton:0];
    }
}

#pragma mark -Setter methods
- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    
    [self setButtonTitleColor:normalColor forState:UIControlStateNormal];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    
    [self setButtonTitleColor:selectedColor forState:UIControlStateSelected];
}

- (void)setPointColor:(UIColor *)pointColor{
    _pointColor = pointColor;
    
    [self addCircleView];
}

// 设置默认首选项
- (void)setDefaultIndex:(NSInteger)defaultIndex
{
    _defaultIndex = defaultIndex;
    
    // 移动contentView到对应位置
    [self moveToButton:defaultIndex];
}

- (void)setOptionMargin:(NSInteger)optionMargin
{
    _optionMargin = optionMargin;
    
    // 刷新setTitlesArray
    [self setTitlesArray:_titlesArray];
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    
    [self setTitlesArray:_titlesArray];
}

- (void)setTitlesArray:(NSArray *)titlesArray
{
    _titlesArray = titlesArray;
    
    // 添加按钮之前先清空之前的按钮
    [self removeAllSubViews:self.contentView];
    
    [self addAutoButton:titlesArray];
}

/**
 *  移除UIView的所有子视图
 *
 *  @param view 需要移除子视图的UIView
 */
- (void)removeAllSubViews:(UIView *)view
{
    if (view.subviews.count) {
        for (UIView *subView in view.subviews) {
            [subView removeFromSuperview];
        }
    }
}

/**
 *  设置指定状态下按钮文字颜色
 *
 *  @param color 文字样色
 *  @param state 控件状态
 */
- (void)setButtonTitleColor:(UIColor *)color forState:(UIControlState)state
{
    if (self.contentView) {
        for (UIView *subView in self.contentView.subviews) {
            if ([subView isKindOfClass:[UIButton class]]) {
                [((UIButton *)subView) setTitleColor:color forState:state];
            }
        }
    }
}

/**
 *  视图增加左右滑动手势
 */
- (void)addSwipeGesture
{
    // 左滑手势
    UISwipeGestureRecognizer *gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(swipeHandle:)];
    [gestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self addGestureRecognizer:gestureLeft];
    
    // 右滑手势
    UISwipeGestureRecognizer *gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(swipeHandle:)];
    [gestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self addGestureRecognizer:gestureRight];
}

#pragma mark -手势代码
- (void)swipeHandle:(UISwipeGestureRecognizer *)swipe
{
    if (UISwipeGestureRecognizerDirectionLeft == swipe.direction) {
        //        NSLog(@"left");
        // 索引+1
        NSInteger changedIndex = self.selectedButton.tag + 1;
        NSInteger count = self.titlesArray.count;
        
        if (changedIndex - count >= 0) {
            return;
        }
        
        [self moveToButton:changedIndex animation:YES];
    }
    else if (UISwipeGestureRecognizerDirectionRight == swipe.direction) {
        //        NSLog(@"right");
        // 索引-1
        NSInteger changedIndex = self.selectedButton.tag - 1;
        
        if (changedIndex < 0) {
            return;
        }
        
        [self moveToButton:changedIndex animation:YES];
    }
}

/**
 *  移动到选中的按钮
 *
 *  @param changeIndex 选中按钮的索引值
 */
- (void)swipeButtonWithChange:(NSInteger)changeIndex
{
    [self moveToButton:(self.selectedButton.tag + changeIndex) animation:YES];
}

#pragma mark -Button click method
- (void)btnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    if (self.selectedButton) {
        if ([self.selectedButton isEqual:btn]) {
            return;
        }
    }
    
    // 设置contentView的位置移动
    [self moveToButton:btn.tag animation:YES];
}

- (void)moveToButton:(NSInteger)index animation:(BOOL)hasAnimation
{
    _currentIndex = index;
    // 得到目标button相对contentView左边距的距离
    CGFloat leftMargin = [self.buttonsLeftMarginArray[index] floatValue];
    
    // 目标按钮的宽度
    CGFloat buttonWidth = [self.buttonsWidthArray[index] floatValue];
    
    // 移动距离
    CGFloat moveLength = (leftMargin + buttonWidth/2);
    
    UIButton *toButton = (UIButton *)self.allButtonArray[index];
    // 动画
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.equalTo(self.mas_centerX).offset(-moveLength);
                             make.top.equalTo(self.mas_top);
                             make.bottom.equalTo(self.mas_bottom).offset(-6);
                             make.width.mas_equalTo(contentViewWidth);
                         }];
                         
                         if (hasAnimation) {
                             [self.contentView layoutIfNeeded];
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         self.selectedButton.selected = NO;
                         toButton.selected = YES;
                         self.selectedButton = toButton;
                         
                         //block方法
                         if (self.didSelectedBlock) {
                             __weak HDOptionSlider *weakself = self;
                             self.didSelectedBlock(weakself, toButton.tag);
                         }
                     }];
}

- (void)moveToButton:(NSInteger)index
{
    _currentIndex = index;
    
    // 得到目标button相对contentView左边距的距离
    CGFloat leftMargin = [self.buttonsLeftMarginArray[index] floatValue];
    
    // 目标按钮的宽度
    CGFloat buttonWidth = [self.buttonsWidthArray[index] floatValue];
    
    // 移动距离
    CGFloat moveLength = (leftMargin + buttonWidth/2);
    
    UIButton *toButton = (UIButton *)self.allButtonArray[index];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.equalTo(self.mas_centerX).offset(-moveLength);
                             make.top.equalTo(self.mas_top);
                             make.bottom.equalTo(self.mas_bottom).offset(-6);
                             make.width.mas_equalTo(contentViewWidth);
                         }];
                     }
                     completion:^(BOOL finished) {
                         
                         self.selectedButton.selected = NO;
                         toButton.selected = YES;
                         self.selectedButton = toButton;
                     }];
}

#pragma mark -Other methods
/**
 *  计算字符串的宽度
 *
 *  @param title 要计算宽度的字符串
 *
 *  @return 字符串的宽度
 */
- (CGFloat)sizeForTitle:(NSString *)title
{
    if (0 == self.fontSize) {
        _fontSize =17;
    }
    return [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.fontSize]}].width + 10;
}

@end

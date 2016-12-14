//
//  StarView.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDStarView.h"
#import "HDDeviceInfo.h"

#define kHDStarViewUnSelectStarImage @"icon_huisexingxing"

@interface HDStarView ()

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) BOOL canClick;

@end

@implementation HDStarView

- (instancetype)initWithStarNumber:(NSInteger)starNumber
                            height:(CGFloat)height
                            margin:(CGFloat)margin
{
    if (self = [super init]) {
        self.height = height;
        self.margin = margin;
        
        self.starNumber = starNumber;
    }
    return self;
}

#pragma mark - Setter
- (void)setStarNumber:(NSInteger)starNumber
{
    _starNumber = starNumber;
    
    NSArray *subViews = self.subviews;
    if (subViews.count > 0) {
        for (NSInteger index = 0; index < 5; index++) {
            
            UIButton *starButton = subViews[index];
            
            if (index >= starNumber) {
                [starButton setSelected:YES];
                [starButton setHidden:!self.canClick]; // 可点击是显示,不可点击时隐藏
            }
            else {
                [starButton setSelected:NO];
            }
            
            if (starNumber == 0) {
                // 为0为一颗星
                if(index > 0) {
                    [starButton setSelected:YES];
                    [starButton setHidden:!self.canClick]; // 可点击是显示,不可点击时隐藏
                }
                else {
                    [starButton setSelected:NO];
                }
            }
        }
    }
    else {
        // 没有创建星星
        for (NSInteger index = 0; index < 5; index++) {
            UIButton *starButton = [[UIButton alloc] init];
            
            [starButton setTag:index];
            [starButton setBackgroundImage:[UIImage imageNamed:@"icon_huangsexingxing"] forState:UIControlStateNormal];
            [starButton setBackgroundImage:[UIImage imageNamed:@"icon_huangsexingxing"] forState:UIControlStateHighlighted];
            [starButton setBackgroundImage:[UIImage imageNamed:kHDStarViewUnSelectStarImage] forState:UIControlStateSelected];
            
            [starButton addTarget:self action:@selector(starClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat starHeight = self.height;
            CGFloat starWidth  = starHeight * 31/32;
            
            [starButton setFrame:CGRectMake(index * (starWidth + self.margin), 0, starWidth, starHeight)];
            
            [self addSubview:starButton];
            
            if (starNumber == 0) {
                // 为0为一颗星
                if(index > 0) {
                    [starButton setSelected:YES];
                }
                else {
                    [starButton setSelected:NO];
                }
            }
            
            if (index >= starNumber) {
                [starButton setSelected:YES];
            }
            else {
                [starButton setSelected:NO];
            }
        }
    }
}

- (void)setStarCanClick:(BOOL)starCanClick
{
    _canClick = starCanClick;
    
    NSArray *subViews = self.subviews;
    if (subViews.count > 0) {
        for (UIButton *subView in subViews) {
            [subView setUserInteractionEnabled:starCanClick];
        }
    }
}

#pragma mark - Star click
- (void)starClick:(UIButton *)sender
{
    NSArray *subViews = self.subviews;
    if (subViews.count > 0) {
        NSInteger sendTag = sender.tag;
        
        for (UIButton *subView in subViews) {
            if (subView.tag > sendTag) {
                [subView setSelected:YES];
            }
            else {
                [subView setSelected:NO];
            }
        }
    }
}

@end

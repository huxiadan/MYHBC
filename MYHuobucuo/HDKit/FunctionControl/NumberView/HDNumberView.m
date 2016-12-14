//
//  HDNumberView.m
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDNumberView.h"

#import <Masonry.h>

@interface HDNumberView ()

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *subButton;

@end

@implementation HDNumberView

- (instancetype)initWithNumber:(NSInteger)number viewHeight:(CGFloat)height
{
    if (self = [super init]) {
        
        [self.layer setBorderWidth:.5f];
        [self.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.layer setCornerRadius:13.f/2];
        [self.layer setMasksToBounds:YES];
        
        self.canEdit = YES;
        
        self.number = number;
        
        self.subButton = [[UIButton alloc] init];
        [self.subButton setImage:[UIImage imageNamed:@"ic_jian1.png"] forState:UIControlStateNormal];
        [self.subButton addTarget:self action:@selector(subButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.subButton.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.subButton.layer setBorderWidth:.5f];
        
        [self addSubview:self.subButton];
        [self.subButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.width.mas_equalTo(height);
        }];
        
        self.addButton = [[UIButton alloc] init];
        [self.addButton setImage:[UIImage imageNamed:@"ic_jia1.png"] forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton.layer setBorderColor:[UIColor blackColor].CGColor];
        [self.addButton.layer setBorderWidth:.5f];
        
        [self addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(self);
            make.width.mas_equalTo(height);
        }];
        
        self.numberLabel = [[UILabel alloc] init];
        [self.numberLabel setText:[NSString stringWithFormat:@"%ld",number]];
        [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.subButton.mas_right);
            make.right.equalTo(self.addButton.mas_left);
        }];
        
    }
    return self;
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    
    self.subButton.enabled = self.canEdit;
    self.addButton.enabled = self.canEdit;
}

#pragma mark - button click
// 减按钮点击
- (void)subButtonClick:(UIButton *)sender
{
    if (self.numberWillChangeBlock) {
        self.numberWillChangeBlock(self.number, NumberChangeType_Sub);
    }
    
    self.number--;
    if (self.number <= 0) {
        self.number++;
        return;
    }
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld",self.number]];
    
    if (self.numberDidChangeBlock) {
        self.numberDidChangeBlock(self.number, NumberChangeType_Sub);
    }
}

// 加按钮点击
- (void)addButtonClick:(UIButton *)sender
{
    if (self.numberWillChangeBlock) {
        self.numberWillChangeBlock(self.number, NumberChangeType_Add);
    }
    
    self.number++;
    if (self.maxNumber != 0) {
        if (self.number > self.maxNumber) {
            self.number--;
            if (self.numberOverMaxBlock) {
                self.numberOverMaxBlock(self.maxNumber);
            }
            return;
        }
    }
    
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld",self.number]];
    
    if (self.numberDidChangeBlock) {
        self.numberDidChangeBlock(self.number, NumberChangeType_Add);
    }
}

#pragma mark - Setter
- (void)setFontSize:(CGFloat)fontSize
{
    [self.numberLabel setFont:[UIFont systemFontOfSize:fontSize]];
}

- (void)setMaxNumber:(NSInteger)maxNumber
{
    _maxNumber = maxNumber;
    
    if (self.number > _maxNumber) {
        self.number = _maxNumber;
        [self.numberLabel setText:[NSString stringWithFormat:@"%ld",self.number]];
    }
}

@end

//
//  HDWelcomeView.m
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDWelcomeView.h"

#import <Masonry.h>

@interface HDWelcomeView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIButton *jumpButton;

@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, assign) BOOL hasEnterButton;

@end

@implementation HDWelcomeView

+ (BOOL)isNeedShowWelcomeView
{
    BOOL isShow = [[HDUserDefaults objectForKey:cVersion] boolValue];
    return isShow;
}

- (instancetype)initWithImagesArray:(NSArray *)imageArray
                    showPageControl:(BOOL)pageControl
                    showEnterButton:(BOOL)enterButton
                     showJumpButton:(BOOL)jumpButton
{
    if (self = [super init]) {
        [self initUIWithArray:imageArray hasPageControl:pageControl hasEnterButton:enterButton hasJumpButton:jumpButton];
    }
    return self;
}

- (void)initUIWithArray:(NSArray *)imagesArray
         hasPageControl:(BOOL)hasPageControl
         hasEnterButton:(BOOL)hasEnterButton
          hasJumpButton:(BOOL)hasJumpButton
{
    [self setFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setDelegate:self];
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
    
    [self.scrollView setContentSize:CGSizeMake(kAppWidth * imagesArray.count, 0)];
    [self.scrollView setPagingEnabled:YES];
    
    CGFloat x = 0;
    for (NSString *imageName in imagesArray) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, kAppWidth, kAppHeight)];
        [imageView setImage:[UIImage imageNamed:imageName]];
        
        x += kAppWidth;
        [self.scrollView addSubview:imageView];
    }
    self.imagesCount = [imagesArray count];
    
    // pageControl
    if (hasPageControl) {
        self.pageControl = [[UIPageControl alloc] init];
        [self.pageControl setNumberOfPages:[imagesArray count]];
        CGSize pageSize = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
        [self.pageControl setFrame:CGRectMake(0, 0, pageSize.width, pageSize.height)];
        [self.pageControl setCenter:CGPointMake((kAppWidth - pageSize.width)/2, kAppHeight - pageSize.height)];
        [self addSubview:self.pageControl];
    }
    
    // jumpButton
    if (hasJumpButton) {
        self.jumpButton = [[UIButton alloc] init];
        self.jumpButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [self.jumpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.jumpButton setBackgroundColor:[UIColor lightGrayColor]];
        [self.jumpButton setAlpha:0.7f];
        [self.jumpButton setTitle:@"跳过" forState: UIControlStateNormal];
        [self.jumpButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.jumpButton];
        
        [self.jumpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(10);
            make.right.equalTo(self.mas_right).offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
    }
    
    // enterButton
    self.hasEnterButton = hasEnterButton;
    if (hasEnterButton) {
        self.enterButton = [[UIButton alloc] init];
        [self.enterButton setAlpha:0];
        [self.enterButton setHidden:YES];
        [self.enterButton setTitle:@"点击进入" forState:UIControlStateNormal];
        [self.enterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.enterButton setBackgroundColor:[UIColor lightTextColor]];
        [self.enterButton setAlpha:0.8f];
        [self.enterButton.layer setCornerRadius:10.f];
        [self.enterButton.layer setMasksToBounds:YES];
        [self.enterButton addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.enterButton];
        [self.enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.bottom.equalTo(self.pageControl.mas_top).offset(-10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(40);
        }];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger number = [[NSNumber numberWithFloat:(offsetX/kAppWidth)] integerValue];
    self.pageControl.currentPage = number;
    
    // 最后一页
    if (number == self.imagesCount - 1) {
        if (self.hasEnterButton) {
            [self.enterButton setHidden:NO];
            [UIView animateWithDuration:0.3f animations:^{
                [self setAlpha:1];
            }];
        }
    }
}

#pragma mark - button click

- (void)hideView
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end

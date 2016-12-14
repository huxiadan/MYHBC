//
//  BaiXianBaiPinHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BaiXianBaiPinHeaderView.h"
#import <SDCycleScrollView.h>

@interface BaiXianBaiPinHeaderView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@end

@implementation BaiXianBaiPinHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:viewControllerBgColor];
        
        // 添加轮播图
        CGFloat bannerHeight = fScreen(460);
        
        SDCycleScrollView *cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
        [self addSubview:cycleView];
        self.cycleView = cycleView;
        [cycleView setFrame:CGRectMake(0, 0, kAppWidth, bannerHeight)];
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.bannerBlock) {
        self.bannerBlock(index);
    }
}

- (void)setBannerArray:(NSArray *)bannerArray
{
    _bannerArray = bannerArray;
    
    self.cycleView.imageURLStringsGroup = bannerArray;
}

@end

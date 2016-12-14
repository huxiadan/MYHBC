//
//  GroupbuyTabHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyTabHeaderView.h"
#import <SDCycleScrollView.h>
#import <Masonry.h>

@interface GroupbuyTabHeaderView () <SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView *cycleView;

@end

@implementation GroupbuyTabHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setBackgroundColor:viewControllerBgColor];
        
        SDCycleScrollView *cycle = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:[UIImage imageNamed:@""]];
        [self addSubview:cycle];
        [cycle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self).offset(fScreen(-20));
        }];
        self.cycleView = cycle;
    }
    return self;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.clickBlock) {
        self.clickBlock(index);
    }
}

- (void)setImagesArray:(NSArray<BannerModel *> *)imagesArray
{
    _imagesArray = imagesArray;
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:imagesArray.count];
    for (BannerModel *model in imagesArray) {
        [tmpArray addObject:model.imageUrl];
    }
    self.cycleView.imageURLStringsGroup = [tmpArray copy];
}

@end

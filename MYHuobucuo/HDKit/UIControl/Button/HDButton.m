//
//  HDButton.m
//  Huobucuo
//
//  Created by hudan on 16/9/5.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "HDButton.h"

@implementation HDButton

- (instancetype)init
{
    if (self = [super init]) {
        [self addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClick
{
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

#pragma mark - 文字图片布局
- (void)setImageTitleType:(HDImageTitle)imageTitleType
{
    switch (imageTitleType) {
        case HDImageTitleLeftTitle:
        case HDImageTitleBottomTitle:
//        case HDImageTitleTopTitle:
        {
            _imageTitleType = imageTitleType;
            [self setNeedsLayout];
        }
            break;
        case HDImageTitleNormal:
        default:
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageTitleType == HDImageTitleNormal) {
        return;
    }
    else if (self.imageTitleType == HDImageTitleLeftTitle) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width, 0, self.imageView.image.size.width)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
    }
    else if (self.imageTitleType == HDImageTitleBottomTitle) {
        
        CGFloat margin = (self.frame.size.height - self.imageView.frame.size.height - self.titleLabel.frame.size.height)/3;
        
        // image
        CGPoint center = self.imageView.center;
        center.x = self.frame.size.width/2;
        center.y = self.imageView.frame.size.height/2 + margin;
        self.imageView.center = center;
        
        //Center text
        CGRect newFrame = [self titleLabel].frame;
        newFrame.origin.x = 0;
        newFrame.origin.y = self.imageView.frame.size.height + margin*2 - 1;
        newFrame.size.width = self.frame.size.width;
        
        self.titleLabel.frame = newFrame;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
//    else {
//        
//    }
}


@end

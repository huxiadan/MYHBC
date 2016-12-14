//
//  HDControllersView.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/25.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "HDControllersView.h"
#import "HDDeviceInfo.h"
#import <Masonry.h>

@interface HDControllersView () <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger currIndex;

@end

@implementation HDControllersView

- (instancetype)initFrame:(CGRect)frame controllers:(NSArray *)controllers
{
    if (self = [super initWithFrame:frame]) {
        self.pagingEnabled = YES;
        self.bounces       = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate      = self;
        self.childControllers = controllers;
    }
    return self;
}

- (void)setChildControllers:(NSArray *)childControllers
{
    [self updateChildControllers:childControllers];
    
    _childControllers = childControllers;
}

- (void)updateChildControllers:(NSArray *)controllers
{
    if ([self.subviews count] > 0) {
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
    }
    
    CGFloat x = 0;
    
    for (UIViewController *controller in controllers) {
        UIView *subView = controller.view;
        [subView setFrame:CGRectMake(x, 0, kAppWidth, self.frame.size.height)];
        [self addSubview:controller.view];
        
        x += kAppWidth;
    }
    
    self.contentSize = CGSizeMake(x, 0);
    self.currIndex = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat tmpIndex = scrollView.contentOffset.x/kAppWidth;
    NSInteger index = [[NSNumber numberWithFloat:tmpIndex] integerValue];
    
//    DLog(@"index = %ld",index);
    
    if (index != self.currIndex) {
        self.currIndex = index;
        if (self.viewMoveBlock) {
            self.viewMoveBlock(index);
        }
    }
}

- (void)moveToController:(NSInteger)index
{
    if (index == self.currIndex) {
        return;
    }
    
    if (self.currIndex > index) {
        CGPoint tOffset = CGPointMake((index + 1)*kAppWidth, 0);
        self.contentOffset = tOffset;
    }
    else if (self.currIndex < index) {
        CGPoint tOffset = CGPointMake((index - 1)*kAppWidth, 0);
        self.contentOffset = tOffset;
    }
    
    CGPoint offset = CGPointMake(index * kAppWidth, 0);
    [UIView animateWithDuration:0.3f animations:^{
        self.contentOffset = offset;
    }];
}

@end

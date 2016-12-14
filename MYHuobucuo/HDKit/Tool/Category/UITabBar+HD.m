//
//  UITabBar+HD.m
//  Test
//
//  Created by hudan on 16/9/12.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "UITabBar+HD.h"

#define kItemCount 4
#define kBageViewLabelTag 100
#define kBageViewLabelFontSize 15.f
#define kBageViewTopMargin 5.f

@implementation UITabBar (HD)

- (void)setBadgValueWithIndex:(NSInteger)index number:(NSString *)number backgroundColor:(UIColor *)bgColor textColor:(UIColor *)textColor
{
    CGRect tabBarFrame = self.frame;
    
    // 当前 item 的 x 中心位置
    CGFloat itemWidth = tabBarFrame.size.width/kItemCount;
    CGFloat centerX   = itemWidth * index + itemWidth/2;
    
    // 创建显示 label
    // 如果有之前的 label, 先移除之前的 label
    UIView *orgLabelView = [self viewWithTag:(index + kBageViewLabelTag)];
    if (orgLabelView) {
        [orgLabelView removeFromSuperview];
    }
    
    UILabel *badgLabel = [[UILabel alloc] init];
    [badgLabel setTag:(index + kBageViewLabelTag)];
    [badgLabel setBackgroundColor:bgColor];
    [badgLabel setTextColor:textColor];
    [badgLabel setTextAlignment:NSTextAlignmentCenter];
    
    // 处理 number: 超过99显示99+
    NSInteger tmpNumber = [number integerValue];
    if (tmpNumber > 99) {
        number = @"99+";
    }
    [badgLabel setText:number];
    CGSize textSize = [number sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kBageViewLabelFontSize]}];
    
    [badgLabel.layer setCornerRadius:textSize.height/2];
    [badgLabel.layer setMasksToBounds:YES];
    [badgLabel setFrame:CGRectMake(centerX - kBageViewTopMargin, kBageViewTopMargin,
                                   textSize.width + 4 <= textSize.height ? textSize.height : textSize.width + 4, textSize.height)];
    NSLog(@"w = %f,  h = %f",textSize.width,textSize.height);
    
    [self addSubview:badgLabel];
}

@end

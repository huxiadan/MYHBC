//
//  HDTextField.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDTextField.h"

@implementation HDTextField

- (void)setLeftMargin:(CGFloat)leftMargin
{
    UIView *leftView = [[UIView alloc] init];
    [leftView setFrame:CGRectMake(0, 0, leftMargin, 1)];
    
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

@end

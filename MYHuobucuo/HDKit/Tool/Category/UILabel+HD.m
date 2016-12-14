//
//  UILabel+HD.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "UILabel+HD.h"

@implementation UILabel (HD)

- (CGFloat)caculateHeightWithWidth:(CGFloat)width
{
    if (self.text.length > 0) {
        CGSize textSize = [self.text boundingRectWithSize:CGSizeMake(width, 1000.0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil].size;
        return textSize.height;
    }
    else {
        return 0;
    }
}

@end

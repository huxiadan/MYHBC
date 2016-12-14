//
//  EvaluateModel.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "EvaluateModel.h"

@implementation EvaluateModel

- (void)setContentText:(NSString *)contentText
{
    _contentText = [contentText copy];
    
    CGFloat containWidth = kAppWidth - fScreen(28 + 30);
    CGSize containSize = CGSizeMake(containWidth, MAXFLOAT);
    CGSize contentSize = [contentText boundingRectWithSize:containSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]} context:nil].size;
    
    CGFloat rowHeight = fScreen(20 + 24 + 16 + 16 + 20) + contentSize.height;
    if (self.photoArray.count > 0) {
        rowHeight += fScreen(134);
    }
    if (self.rowHeight < rowHeight) {
        self.rowHeight = rowHeight;
    }
}

- (void)setPhotoArray:(NSArray *)photoArray
{
    _photoArray = photoArray;
    
    if (photoArray.count > 0) {
        CGFloat containWidth = kAppWidth - fScreen(28 + 30);
        CGSize containSize = CGSizeMake(containWidth, MAXFLOAT);
        CGSize contentSize = [self.contentText boundingRectWithSize:containSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]} context:nil].size;
        
        self.rowHeight = fScreen(20 + 24 + 16 + 16 + 20 + 134) + contentSize.height;
    }
}

@end

//
//  HDLabel.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDLabel.h"

#import "NSAttributedString+HD.h"
#import "HDDeviceInfo.h"


@implementation HDLabel

- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)initData
{
    self.width = 0;
}

- (void)setLineSpace:(CGFloat)lineSpace
{
    NSString *text = self.text.length == 0 ? @"填充" : self.text;
    self.attributedText = [NSAttributedString getAttributeString:text lineSpacing:lineSpace];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    NSMutableAttributedString *mAttrString = [[NSMutableAttributedString alloc] initWithString:text];
    [mAttrString addAttributes:@{NSFontAttributeName : self.font} range:NSMakeRange(0, text.length)];
    
    self.attributedText = mAttrString;
}

- (CGFloat)textHeight
{
    if (self.width == 0) {
        self.width = kAppWidth;
    }
    
    CGSize size;
    if (self.attributedText.length != 0) {
        size = [self.attributedText boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size; // NSStringDrawingTruncatesLastVisibleLine |
    }
    else {
        size = [self.text boundingRectWithSize:CGSizeMake(self.width, MAXFLOAT) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil].size;
    }
    
    return size.height + 1;
}

@end

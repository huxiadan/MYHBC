//
//  HDTextView.m
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDTextView.h"

#import "HDDeviceInfo.h"

@interface HDTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation HDTextView

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
        
        self.contentWidth = frame.size.width;
    }
    return self;
}

- (void)initData
{
    self.delegate = self;
    
    self.leftMargin = 0;
    self.contentWidth = [[UIScreen mainScreen] bounds].size.width;
    self.placeholderFontSize = 0;
    self.lineSpace = 0;
}

- (void)placeholderHideToBeginEdit
{
    [self.placeHolderLabel setHidden:YES];
    
    [self becomeFirstResponder];
}

- (NSAttributedString *)getAttributeString:(NSString *)text lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeAtring =[[NSMutableAttributedString alloc]initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:fScreen6(lineSpacing)];
    [attributeAtring addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [attributeAtring addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:NSMakeRange(0, [text length])];
    
    return attributeAtring;
}

#pragma mark - Setter

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    if (self.placeHolderLabel) {
        
        [self.placeHolderLabel removeFromSuperview];
        
        self.placeHolderLabel = nil;
    }
    
    self.placeHolderLabel = [[UILabel alloc] init];
    [self.placeHolderLabel setFont:[UIFont systemFontOfSize:self.placeholderFontSize]];
    [self.placeHolderLabel setTextColor:HexColor(0x999)];
    
    // 添加手势
    UITapGestureRecognizer *tapGtr = [[UITapGestureRecognizer alloc] init];
    [tapGtr addTarget:self action:@selector(placeholderHideToBeginEdit)];
    [self.placeHolderLabel addGestureRecognizer:tapGtr];
    [self.placeHolderLabel setUserInteractionEnabled:YES];
    
    [self.placeHolderLabel setText:placeholder];
    
    CGSize textSize = [placeholder sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:self.placeholderFontSize]}];
    
    [self.placeHolderLabel setFrame:CGRectMake(self.leftMargin, 5, textSize.width + 4, textSize.height)];
    
    [self addSubview:self.placeHolderLabel];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self.placeHolderLabel setFont:font];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.contentWidth = frame.size.width;
}

#pragma mark - Getter
- (CGFloat)placeholderFontSize
{
    if (_placeholderFontSize == 0) {
        _placeholderFontSize = 15.f;
        
//        self.font = [UIFont systemFontOfSize:_fontSize];
    }
    return _placeholderFontSize;
}


- (CGFloat)leftMargin
{
    if (_leftMargin == 0) {
        _leftMargin = 5.f;
    }
    return _leftMargin;
}

#pragma mark - textView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (!self.placeHolderLabel.hidden) {
        [self.placeHolderLabel setHidden:YES];
    }
    
    if ([textView.text isEqualToString:@""] && self.lineSpace != 0) {
        textView.attributedText = [self getAttributeString:@" " lineSpacing:self.lineSpace];    // 设置行间距
    }
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // 去除设置行间距时的空白输入
    NSRange range = [textView.text rangeOfString:@" "];
    if (range.location == 0) {
        NSAttributedString *tmpString = textView.attributedText;
        
        tmpString = [tmpString attributedSubstringFromRange:NSMakeRange(1, tmpString.length - 1)];
        
        textView.attributedText = tmpString;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [self.placeHolderLabel setHidden:NO];
    }
}

@end

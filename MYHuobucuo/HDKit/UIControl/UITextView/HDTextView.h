//
//  HDTextView.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, assign) CGFloat lineSpace;

@property (nonatomic, assign) CGFloat placeholderFontSize;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat contentWidth;

@end

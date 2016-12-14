//
//  HDLabel.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDLabel : UILabel

@property (nonatomic, assign) CGFloat lineSpace;

@property (nonatomic, assign, readonly) CGFloat textHeight;     // 文字高度
@property (nonatomic, assign) CGFloat width;                    // 宽度，用于计算文字高度，若不设置，默认为app宽度

@end

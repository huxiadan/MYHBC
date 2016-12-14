//
//  HDNumberView.h
//  HDKit
//
//  Created by 1233go on 16/7/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger) {
    NumberChangeType_Add = 0,   // 加
    NumberChangeType_Sub = 1,   // 减
}NumberChangeType;

typedef void(^NumberWillChangeBlock)(NSInteger number, NumberChangeType type);
typedef void(^NumberDidChangeBlock)(NSInteger number, NumberChangeType type);
typedef void(^NumberOverMaxBlock)(NSInteger maxNumer);

@interface HDNumberView : UIView

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSInteger maxNumber;      // 最大值

@property (nonatomic, assign) BOOL canEdit; // 加减号是否可以使用

@property (nonatomic, copy) NumberDidChangeBlock numberDidChangeBlock;          // 数字将要改变的block
@property (nonatomic, copy) NumberWillChangeBlock numberWillChangeBlock;        // 数字已经改变的block
@property (nonatomic, copy) NumberOverMaxBlock numberOverMaxBlock;              // 当数字超过最大值时候的block


/**
 初始化方法

 @param number 初始化后显示的数量
 @param height 控件的高度

 @return 实例化的对象
 */
- (instancetype)initWithNumber:(NSInteger)number viewHeight:(CGFloat)height;

@end

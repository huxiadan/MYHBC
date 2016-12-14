//
//  StarView.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  五星视图
 */

#import <UIKit/UIKit.h>

@interface HDStarView : UIView

@property (nonatomic, assign) NSInteger starNumber;     // 选中星星的个数（0 <= starNumber <= 5）

@property (nonatomic, assign) BOOL starCanClick;        // 星星可够点击改变

/**
 初始化方法

 @param starNumber 初始化后星星显示的数量
 @param height 高度
 @return 实例化的对象
 */
- (instancetype)initWithStarNumber:(NSInteger)starNumber height:(CGFloat)height margin:(CGFloat)margin;

@end

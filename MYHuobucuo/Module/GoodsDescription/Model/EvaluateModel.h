//
//  EvaluateModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    评价数据模型
 */

#import <Foundation/Foundation.h>

@interface EvaluateModel : NSObject

@property (nonatomic, copy) NSString *userName;         // 用户名
@property (nonatomic, assign) NSUInteger starNumber;    // 星星数量
@property (nonatomic, copy) NSString *contentText;      // 评价内容
@property (nonatomic, copy) NSString *time;             // 评价时间
@property (nonatomic, strong) NSArray *photoArray;      // 评价图片

@property (nonatomic, assign) CGFloat rowHeight;        // 行高
@property (nonatomic, assign) BOOL isNoPhotoShow;       // 不显示照片(商品详情首页使用)

- (void)setValueWithDict:(NSDictionary *)dict;

@end

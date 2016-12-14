//
//  CategoryDetailModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    分类界面右侧子分类的数据模型
 */

@interface CategoryDetailModel : NSObject

@property (nonatomic, copy) NSString *categoryId;       // 子分类的 id, 用于界面跳转
@property (nonatomic, copy) NSString *categoryName;     // 名称
@property (nonatomic, copy) NSString *categoryImageURL; // 图片

@end

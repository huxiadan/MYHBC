//
//  ReviewsPhotosView.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    商品评价图片选择视图
 */

#import <UIKit/UIKit.h>

@interface ReviewsPhotosView : UIView

@property (nonatomic, strong) UINavigationController *navController;

@end


#pragma mark - reviewPhotoTmpObject 用于记录图片和对应的删除按钮
@interface ReviewPhotoTmpObject : NSObject

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL hidden;

// 设置第一个为添加
- (void)setFirstAddButton;

@end

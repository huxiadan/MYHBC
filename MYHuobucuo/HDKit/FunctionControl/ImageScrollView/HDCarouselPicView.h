//
//  HDImageScrollView.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    轮播图(普通模式)
 */

#import <UIKit/UIKit.h>

@class HDCarouselPicView;

typedef void(^CarouselPicClickBlock)(HDCarouselPicView *imageScrollView);

@interface HDCarouselPicView : UIView

@property (nonatomic, copy) CarouselPicClickBlock carouselPicClickBlock;

/**
    dataArray
 */

/**
  初始化方法

 @param frame           frame
 @param dataArray       每个 cell 的数据模型的数组
 @param placeholderName 占位图的名称

 @return 实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray placeholder:(NSString *)placeholderName;

@end


@interface HDCarouselPicViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageShowView;

@end

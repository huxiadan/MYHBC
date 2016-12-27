//
//  CategoryDetailView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    分类跳转详细视图
 */

#import <UIKit/UIKit.h>

@interface CategoryDetailView : UICollectionView

@property (nonatomic, strong) NSArray *modelArray;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                        title:(NSString *)title
                   modelArray:(NSArray *)modelArray;

@end

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
#import "GoodsModel.h"

typedef void(^CellClickBlock)(GoodsModel *model);

@interface CategoryDetailView : UICollectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                        title:(NSString *)title
                   modelArray:(NSArray *)modelArray;

@property (nonatomic, strong) CellClickBlock cellBlock;

@end
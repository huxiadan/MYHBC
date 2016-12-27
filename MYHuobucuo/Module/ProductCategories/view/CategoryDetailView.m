//
//  CategoryDetailView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "CategoryDetailView.h"
#import "CategoryHeaderView.h"
#import "CategoryDetailCollCell.h"
#import "HDRefresh.h"

@interface CategoryDetailView ()

@property (nonatomic, copy) NSString *headerTitle;

@end

@implementation CategoryDetailView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                        title:(NSString *)title
                   modelArray:(NSArray *)modelArray
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {

        
        [self registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [self registerClass:[CategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
        
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}

@end

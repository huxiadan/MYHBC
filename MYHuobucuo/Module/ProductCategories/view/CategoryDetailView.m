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

@interface CategoryDetailView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, strong) NSArray *modelArray;

@end

@implementation CategoryDetailView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                        title:(NSString *)title
                   modelArray:(NSArray *)modelArray
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.headerTitle = title;
        self.modelArray = modelArray;
        
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [self registerClass:[CategoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
        
        self.showsVerticalScrollIndicator = NO;
    }
    return self;
}


#pragma mark - dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modelArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collidentity forIndexPath:indexPath];
    
    GoodsModel *model = [self.modelArray objectAtIndex:indexPath.item];
    cell.goodsModel = model;
    
    cell.addShoppingCarBlock = ^(GoodsModel *goodsModel) {
        NSLog(@"挨打的各类科技节哀");
    };
    
    return cell;
}


#pragma mark - delegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        CategoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity forIndexPath:indexPath];
        
        NSString *titleText = self.headerTitle;
        headerView.titleText = titleText;
        
        reusableview = headerView;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellBlock) {
        GoodsModel *model = (GoodsModel *)[self.modelArray objectAtIndex:indexPath.item];
        self.cellBlock(model);
    }
}

@end

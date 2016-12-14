//
//  ShopHotRecommView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShopHotRecommView.h"
#import "CategoryDetailCollCell.h"
#import <Masonry.h>

@interface ShopHotRecommView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *listView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation ShopHotRecommView

- (instancetype)initWithHotArray:(NSArray *)array
{
    if (self = [super init]) {
        self.dataList = array;
        
        [self addSubview:self.listView];
        [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - collectionView dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collidentity forIndexPath:indexPath];
    
    GoodsModel *model = (GoodsModel *)[self.dataList objectAtIndex:indexPath.item];
    cell.goodsModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (self.clickBlock) {
        GoodsModel *model = (GoodsModel *)[self.dataList objectAtIndex:indexPath.item];
        
        self.clickBlock(model.goodsId);
    }
}

- (UICollectionView *)listView
{
    if (!_listView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = fScreen(20);
        layout.minimumInteritemSpacing = fScreen(18);
        
        CGFloat itemWdith = (kAppWidth - fScreen(30*2) - fScreen(18))/2;
        
        if ([HDDeviceInfo isIPhone4Size] || [HDDeviceInfo isIPhone5Size]) {
            layout.itemSize = CGSizeMake(itemWdith - 1, fScreen(468));
        }
        else {
            layout.itemSize = CGSizeMake(itemWdith, fScreen(468));
        }
        
        layout.sectionInset = UIEdgeInsetsMake(0, fScreen(30), 0, fScreen(30));
        
        _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_listView setBackgroundColor:viewControllerBgColor];
        [_listView setShowsVerticalScrollIndicator:NO];
        [_listView registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [_listView setDataSource:self];
        [_listView setDelegate:self];
        [_listView setBounces:NO];
    }
    return _listView;
}

@end

//
//  GoodsRecommendController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsRecommendController.h"
#import "CategoryDetailCollCell.h"
#import <Masonry.h>

@interface GoodsRecommendController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collection;

@property (nonatomic, strong) NSArray *dataList;

@end

@implementation GoodsRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 19; i++) {
        GoodsModel *model = [[GoodsModel alloc] init];
        model.goodsName = @"平和红心蜜柚平和红心蜜柚5斤两颗装adfedfdffffdddddd";
        model.goodsPrice = @"22.8";
        model.marketPrice = @"32.9";
        [tmpArray addObject:model];
    }
    
    self.dataList = [tmpArray copy];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self.view addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-fScreen(112) - fScreen(88) - 20);
    }];
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
    
}

- (UICollectionView *)collection
{
    if (!_collection) {
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
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collection setBackgroundColor:viewControllerBgColor];
        [_collection setShowsVerticalScrollIndicator:NO];
        [_collection registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [_collection setDataSource:self];
        [_collection setDelegate:self];
        
        [_collection setContentInset:UIEdgeInsetsMake(fScreen(20), 0, 0, 0)];
    }
    return _collection;
}

@end

//
//  MainModelController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/10.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MainModelController.h"
#import "CategoryDetailCollCell.h"
#import "MainModelCollHeader.h"
#import "MainModelHeaderModel.h"
#import "GoodsViewController.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>

#define kKeyHeader @"header"
#define kkeyArray @"array"

@interface MainModelController () <UICollectionViewDataSource, UICollectionViewDelegate , SDCycleScrollViewDelegate>

//@property (nonatomic, strong) HDCarouselPicView *picView;   // 轮播图
@property (nonatomic, strong) SDCycleScrollView *picView;
@property (nonatomic, strong) UICollectionView *listView;

@property (nonatomic, strong) NSArray *dataList;    /** 元素是字典,字典 
                                                        title: section 中 headerView 的数据
                                                        array:collectionview 中 section 的 item
                                                     数组
                                                     */



@end

@implementation MainModelController

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
    
    for (NSInteger index = 0; index < 4; index++) {
        MainModelHeaderModel *headerModel = [[MainModelHeaderModel alloc] init];
        headerModel.mainTitle = @"旺仔牛奶";
        headerModel.subTitle = @"再看我就把你喝掉";
        
        NSMutableArray *itemArray = [NSMutableArray array];
        for (NSInteger i = 0; i < 7; i++) {
            GoodsModel *model = [[GoodsModel alloc] init];
            model.goodsName = @"平和红心蜜柚平和红心蜜柚5斤两颗装adfedfdffffdddddd";
            model.goodsPrice = @"22.8";
            model.marketPrice = @"32.9";
            [itemArray addObject:model];
        }
        
        NSDictionary *dict = @{kKeyHeader : headerModel,
                               kkeyArray : [itemArray copy]};
        
        [tmpArray addObject:dict];
    }
    self.dataList = [tmpArray copy];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];

    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(1);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100);
    }];
}


#pragma mark - collectionView dataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSDictionary *dict = (NSDictionary *)[self.dataList objectAtIndex:section];
    NSArray *array = (NSArray *)[dict objectForKey:@"array"];
    return [array count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.dataList count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collidentity forIndexPath:indexPath];
    
    NSDictionary *dict = (NSDictionary *)[self.dataList objectAtIndex:indexPath.section];
    NSArray *array = (NSArray *)[dict objectForKey:@"array"];
    GoodsModel *model = (GoodsModel *)[array objectAtIndex:indexPath.item];
    
    cell.goodsModel = model;
    cell.addShoppingCarBlock = ^(GoodsModel *goodsModel) {
    
    };
    
    return  cell;
}


#pragma mark - collectionView delegate

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        MainModelCollHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity forIndexPath:indexPath];
        
        NSDictionary *dict = (NSDictionary *)[self.dataList objectAtIndex:indexPath.section];
        MainModelHeaderModel *model = (MainModelHeaderModel *)[dict objectForKey:@"header"];
        headerView.model = model;
        
        reusableview = headerView;
    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsViewController *goodsVC = [[GoodsViewController alloc] init];
    [self.currNavigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

}

#pragma mark - Getter
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
        
        layout.headerReferenceSize = CGSizeMake(kAppWidth, fScreen(20 + 88 + 20));
        
        layout.sectionInset = UIEdgeInsetsMake(0, fScreen(30), 0, fScreen(30));
        
        _listView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_listView setBackgroundColor:viewControllerBgColor];
        [_listView setShowsVerticalScrollIndicator:NO];
        [_listView registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [_listView registerClass:[MainModelCollHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
        [_listView setDataSource:self];
        [_listView setDelegate:self];
        
        // 添加轮播图到 headerView
        CGFloat picHeight = fScreen(450 - 72);
        CGRect picFrame = CGRectMake(0, -picHeight, kAppWidth, picHeight);
        
        self.picView = [SDCycleScrollView cycleScrollViewWithFrame:picFrame delegate:self placeholderImage:[UIImage imageNamed:@"img_load_rect"]];
        NSArray *picArray = @[@"http://pic.58pic.com/58pic/17/37/33/29A58PICGX5_1024.jpg", @"http://pic.90sjimg.com/back_pic/00/04/27/49/d729357f0fdf8eaec3433cb495949ede.jpg", @"http://pic2.ooopic.com/12/80/79/89bOOOPICd2_1024.jpg"];
        self.picView.imageURLStringsGroup = picArray;
        
        [_listView setContentInset:UIEdgeInsetsMake(picHeight, 0, 0, 0)];
        [_listView addSubview:self.picView];
    }
    return _listView;
}

@end

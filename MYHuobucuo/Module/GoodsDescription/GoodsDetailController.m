//
//  GoodsDetailController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/14.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsDetailController.h"
#import "GoodsDetailModel.h"
#import <Masonry.h>
#import <SDCycleScrollView.h>
#import "EvaluateTabCell.h"
#import <UIImageView+WebCache.h>
#import "GoodsDetailCollHeaderView.h"
#import "CategoryDetailCollCell.h"
#import "GoodsDetailCollFooterView.h"
#import "GoodsDetailBottomView.h"
#import "StoreViewController.h"
#import "HDLabel.h"
#import "GoodsDetailCollGroupNoMoneyHeader.h"
#import "GoodsDetailCollGroupMoneyHeader.h"

@interface GoodsDetailController () <SDCycleScrollViewDelegate,
                                    UICollectionViewDelegate,
                                    UICollectionViewDataSource>

// UI
@property (nonatomic, strong) UICollectionView *recommendView;  // 推荐商品

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *priceLabel;

// Data
@property (nonatomic, strong) GoodsDetailModel *goodsModel;

@property (nonatomic, strong) NSArray *dataList;                // 推荐的数据源

@property (nonatomic, assign) CGFloat headerHeight;             // collectionView 头高

@property (nonatomic, strong) NSString *price;                  // 当前的单价

@end

@implementation GoodsDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    
    [self hideNavigationBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.goodsModel.isGroup) {
        
        GoodsDetailCollGroupNoMoneyHeader *headerView = (GoodsDetailCollGroupNoMoneyHeader *)[self.recommendView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collNoMoneyHeaderViewIdentity forIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [headerView endTimer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSInteger index = 0; index < 4; index++) {
        
        for (NSInteger i = 0; i < 7; i++) {
            
            GoodsModel *model = [[GoodsModel alloc] init];
            
            model.goodsName = @"平和红心蜜柚平和红心蜜柚5斤两颗装adfedfdffffdddddd";
            
            model.goodsPrice = @"22.8";
            
            model.marketPrice = @"32.9";
            
            [tmpArray addObject:model];
        }
    }
    
    self.dataList = [tmpArray copy];
}

- (instancetype)initWithGoodsModel:(GoodsDetailModel *)goodsModel bottomView:(UIView *)bottomView
{
    if (self = [super init]) {
        self.bottomView = bottomView;
        
        self.goodsModel = goodsModel;
        
//        self.goodsModel.isGroup = YES;
        self.goodsModel.groupType = GroupType_Normal;
        self.goodsModel.groupNumber = 4;
        self.goodsModel.hasNumber = 2;
        self.goodsModel.goodsInfoString = @"小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女";
        self.goodsModel.fromPlace = @"厦门后埔红灯区";
        self.goodsModel.salePromote = @"本店还有2个小仙女正在促销";
        self.goodsModel.endTime = 18990;
        self.goodsModel.rulesArray = @[@"小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙女", @"小仙女小仙女小仙女小仙", @"小仙女小仙女小仙女小仙女小仙女小仙女小仙女小仙"];
        
        // 拼团
        NSMutableArray *tmpArray = [NSMutableArray array];
        
        for (NSInteger index = 0; index < 3; index++) {
            
            OtherGroupModel *model = [[OtherGroupModel alloc] init];
            
            model.groupUserName = @"如花小仙女";
            
            model.noEnoughNumber = 2;
            
            model.endTime = 324;
            
            [tmpArray addObject:model];
        }
        
        self.goodsModel.otherGroupsArray = [tmpArray copy];
        
        self.headerHeight = [self caculateHeaderViewHeightWithModel:goodsModel];
    }
    return self;
}

- (CGFloat)caculateHeaderViewHeightWithModel:(GoodsDetailModel *)model
{
    CGFloat viewHeight = 0;
    
    // 轮播图
    viewHeight += kAppWidth;
    
    if (self.goodsModel.isGroup) {
        // 拼团商品
        // 名称 间距20 + 间距26 + 价格40 + 间距20 + 免运费 + 厂家54 + 名称高度 + 说明高度
        if (self.goodsModel.groupType == GroupType_Normal) {
            viewHeight += fScreen(20 + 26 + 40 + 20 + 20 + 52 + 20 + 54 + 26) + 2;
        }
        else {
            viewHeight += fScreen(20 + 26 + 40 + 20 + 20 + 52 + 20 + 54) + 2;
        }
        
        CGFloat labelWidth = kAppWidth - fScreen(28 * 2);
        
        CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
        
        CGSize nameSize = [model.goodsName boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} context:nil].size;
        
        CGFloat textHeight = [@"高度" sizeForFontsize:fScreen(32)].height;
        
        CGFloat maxHeight = textHeight * 2 + fScreen(5);
        
        CGFloat nameHeight = nameSize.height > maxHeight ? maxHeight : nameSize.height;
        
        CGSize infoSize = [model.goodsName boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} context:nil].size;
        
        viewHeight += nameHeight + infoSize.height;
        
        // 急速/促销
        viewHeight += fScreen(74 * 2) + 1;
        
        // 其他拼团
        viewHeight += fScreen(52 + (129 + 20)*self.goodsModel.otherGroupsArray.count) + fScreen(10);
        
        // 拼团规则
        viewHeight += fScreen(20 + 24 + 28);
        
        HDLabel *label = [[HDLabel alloc] init];
        
        [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
        
        [label setTextColor:HexColor(0x999999)];
        
        [label setWidth:kAppWidth - fScreen(28 * 2 + 18)];
        
        [label setLineSpace:fScreen(10)];
        
        [label setAdjustsFontSizeToFitWidth:YES];
        
        for (NSString *rule in self.goodsModel.rulesArray) {
            
            [label setText:rule];
            
            viewHeight += label.textHeight + fScreen(10);
        }
    }
    else {
        // 普通商品
        // 名称  间距20 + 间距26 + 价格40 + 间距20 + 厂家54 + 名称高度
        viewHeight += fScreen(20 + 26 + 40 + 20 + 54) + 2;
        
        CGFloat labelWidth = kAppWidth - fScreen(30 + 40 + 30 + 160 + 20 + 30);;
        
        CGSize labelSize = CGSizeMake(labelWidth, MAXFLOAT);
        CGSize textSize = [model.goodsName boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(32)]} context:nil].size;
        
        CGFloat textHeight = [@"高度" sizeForFontsize:fScreen(32)].height;
        
        CGFloat maxHeight = textHeight * 2 + fScreen(5);
        
        CGFloat nameHeight = textSize.height > maxHeight ? maxHeight : textSize.height;
        
        viewHeight += nameHeight;
        
        // 服务/分销
        viewHeight += fScreen(148) + fScreen(20);
        
        // 规格
        viewHeight += self.goodsModel.showSpecArray.count * fScreen(28 + 20) + fScreen(20) + fScreen(20);
    }
    
    // 评价
    if (self.goodsModel.evaluateArray.count > 0) {
        
        CGFloat evaHeight = fScreen(80 * 2);
        
        for (EvaluateModel *evaModel in self.goodsModel.evaluateArray) {
            
            evaHeight += evaModel.rowHeight - fScreen(10);
            
        }
        
        viewHeight += evaHeight + fScreen(20);
    }
    else {
        viewHeight -= fScreen(20);
    }
    
    // 店铺
    viewHeight += fScreen(160 + 20);
    
    // headerView
    viewHeight += fScreen(20 + 78 + 20);
    
    return viewHeight;
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addBottomView];
  
    // 同店好货推荐
    [self addRecommendView];
}

- (void)addRecommendView
{
    [self.view addSubview:self.recommendView];
    
    [self.recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(1);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (void)addBottomView
{
    self.bottomView = [[UIView alloc] init];
    
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset([HDDeviceInfo isIPhone6Size] || [HDDeviceInfo isIPhone6PSize] ? -fScreen(15) : 0);        // 屏幕适配
        make.height.mas_equalTo(fScreen(112));
    }];
}



#pragma mark - button click



#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{}

#pragma mark - Getter

- (UICollectionView *)recommendView
{
    if (!_recommendView) {
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
        
        layout.headerReferenceSize = CGSizeMake(kAppWidth, self.headerHeight);
        
        layout.footerReferenceSize = CGSizeMake(kAppWidth, fScreen(50));
        
        layout.sectionInset = UIEdgeInsetsMake(0, fScreen(30), 0, fScreen(30));
        
        _recommendView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        [_recommendView setBackgroundColor:viewControllerBgColor];
        
        [_recommendView setShowsVerticalScrollIndicator:NO];
        
        [_recommendView registerClass:[CategoryDetailCollCell class]
           forCellWithReuseIdentifier:collidentity];
        
        // header
        // 普通商品
        [_recommendView registerClass:[GoodsDetailCollHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity];
        
        // 团购商品(无佣金)
        [_recommendView registerClass:[GoodsDetailCollGroupNoMoneyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collNoMoneyHeaderViewIdentity];
        
        // 团购商品(有佣金)
        [_recommendView registerClass:[GoodsDetailCollGroupMoneyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collMoneyHeaderViewIdentity];
        
        // footer
        [_recommendView registerClass:[GoodsDetailCollFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collFooterViewIdentity];
        
        [_recommendView setDataSource:self];
        
        [_recommendView setDelegate:self];
    }
    return _recommendView;
}

#pragma mark - collectionView dataSource & delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CategoryDetailCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collidentity forIndexPath:indexPath];
    
    GoodsModel *model = [self.dataList objectAtIndex:indexPath.item];
    
    [cell setGoodsModel:model];
    
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        if (self.goodsModel.isGroup) {
            
            // 拼团商品
            if (self.goodsModel.groupType != GroupType_Normal) {
                
                // 限时秒杀团
                GoodsDetailCollGroupNoMoneyHeader *headerView = (GoodsDetailCollGroupNoMoneyHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collNoMoneyHeaderViewIdentity forIndexPath:indexPath];
                
                [headerView setGoodsModel:self.goodsModel];
                
                headerView.navigationController = self.navigationController;
                
                headerView.userInteractionEnabled = YES;
                
                __weak typeof(self) weakSelf = self;

                headerView.toShopBlock = ^(NSString *shopId) {
                    
                    StoreViewController *storeVC = [[StoreViewController alloc] initWithShopId:shopId];
                    
                    [weakSelf.currNavigationController pushViewController:storeVC animated:YES];
                };
                
                headerView.toEvaluteBlock = self.toEvaBlock;
                
                reusableView = headerView;
            }
            else {
                
                GoodsDetailCollGroupMoneyHeader *headerView = (GoodsDetailCollGroupMoneyHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collMoneyHeaderViewIdentity forIndexPath:indexPath];
                
                [headerView setGoodsModel:self.goodsModel];
                
                headerView.navigationController = self.currNavigationController;
                
                headerView.userInteractionEnabled = YES;
                
                __weak typeof(self) weakSelf = self;
                
                headerView.toShopBlock = ^(NSString *shopId) {
                    
                    StoreViewController *storeVC = [[StoreViewController alloc] initWithShopId:shopId];
                    
                    [weakSelf.currNavigationController pushViewController:storeVC animated:YES];
                };
                
                headerView.shareBlock = self.shareBlock;
                
                headerView.toEvaluteBlock = self.toEvaBlock;
                
                reusableView = headerView;
            }
        }
        else {
            // 普通商品
            GoodsDetailCollHeaderView *headerView = (GoodsDetailCollHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collHeaderViewIdentity forIndexPath:indexPath];
            
            [headerView setGoodsModel:self.goodsModel];
            
            headerView.userInteractionEnabled = YES;
            
            __weak typeof(self) weakSelf = self;
            
            headerView.specSelectBlock = ^() {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kGoodsShowSpecSelectViewNoti object:nil];
//                [weakSelf.specSelectView showView];
            };
            
            headerView.toShopBlock = ^(NSString *shopId) {
                
                StoreViewController *storeVC = [[StoreViewController alloc] initWithShopId:shopId];
                
                [weakSelf.currNavigationController pushViewController:storeVC animated:YES];
            };
            
            headerView.toEvaluteBlock = self.toEvaBlock;
            
            reusableView = headerView;
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        
        GoodsDetailCollFooterView *footerView = (GoodsDetailCollFooterView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collFooterViewIdentity forIndexPath:indexPath];
        
        reusableView = footerView;
    }
    return reusableView;
}


@end

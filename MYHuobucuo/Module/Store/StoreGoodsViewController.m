//
//  StoreGoodsController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "StoreGoodsViewController.h"
#import <Masonry.h>
#import "StoreGoodsTabCell.h"
#import "StoreGoodsCollCell.h"
#import "StoreGoodsItem.h"
#import "ShareView.h"
#import "GoodsViewController.h"

@interface StoreGoodsViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

// UI
@property (nonatomic, strong) UIView *itemView;
@property (nonatomic, strong) StoreGoodsItem *currItem;

@property (nonatomic, strong) UITableView *goodsListTabView;            // 商品的 table 展现形式
@property (nonatomic, strong) UICollectionView *goodsListCollView;      // 商品的 collection 展现形式

@property (nonatomic, strong) UIView *mainView;                         // 分享视图的父视图

// DATA
@property (nonatomic, copy) NSString *shopId;                           // 商品 id
@property (nonatomic, assign) BOOL isShowTableView;                     // YES:显示的是 tableView; NO: 显示的是 collectionView
@property (nonatomic, strong) NSArray<StoreGoodsModel *> *goodsArray;   // 商品数据源数组
@property (nonatomic, strong) ShareView *shareView;                     // 分享视图

@end

@implementation StoreGoodsViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.categoryString.length != 0) {
        // 请求数据
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestData];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setCanScroll
{
    if (self.isShowTableView) {
        if (self.goodsListTabView.contentOffset.y != 0) {
            return;
        }
    }
    else {
        if (self.goodsListCollView.contentOffset.y != 0) {
            return;
        }
    }
    [self.goodsListTabView setScrollEnabled:YES];
    [self.goodsListCollView setScrollEnabled:YES];
}

- (void)setCanNotScroll
{
    if (self.isShowTableView) {
        if (self.goodsListTabView.contentOffset.y != 0) {
            return;
        }
    }
    else {
        if (self.goodsListCollView.contentOffset.y != 0) {
            return;
        }
    }
    
    [self.goodsListTabView setScrollEnabled:NO];
    [self.goodsListCollView setScrollEnabled:NO];
}

- (instancetype)initWithShopId:(NSString *)shopId mainView:(UIView *)mainView
{
    if (self = [super init]) {
        self.shopId = shopId;
        self.mainView = mainView;
    }
    return self;
}

- (void)requestData
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:21];
    for (NSInteger index = 0; index < 21; index++) {
        StoreGoodsModel *model = [[StoreGoodsModel alloc] init];
        model.goodsName = @"含笑半步癫 3倍效果.马云笑了,马化腾笑了,李彦宏哭了 含笑半步癫";
        model.goodsPrice = @"98.34";
        model.marketPrice = @"987";
        if (index%3 == 1) {
            model.groupBuy = YES;
        }
        
        [tmpArray addObject:model];
    }
    
    self.goodsArray = [tmpArray copy];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.itemView = [self makeItemView];
    [self.view addSubview:self.itemView];
    [self.itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(1);
        make.height.mas_equalTo(fScreen(68));
    }];
    
    // 默认是 tableView 样式显示
    [self.view addSubview:self.goodsListTabView];
    [self.goodsListTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.itemView.mas_bottom).offset(2);
    }];
    self.isShowTableView = YES;
    
    self.height = kAppHeight - fScreen(88) - 20 - fScreen(88);
}

- (UIView *)makeItemView
{
    UIView *itemView = [[UIView alloc] init];
    [itemView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *titleArray = @[@"全部", @"销量", @"上新", @"价格"];
    
    CGFloat x = fScreen(48);
    CGFloat buttonWidth = (kAppWidth - fScreen(90))/4;
    for (NSInteger index = 0; index < 4; index++) {
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [label setTextColor:HexColor(0x333333)];
        [label setText:[titleArray objectAtIndex:index]];
        
        [itemView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(itemView).offset(x + fScreen(108 + 58)*index);
            make.width.mas_equalTo(fScreen(58));
            make.height.mas_equalTo(fScreen(28));
            make.centerY.equalTo(itemView);
        }];
 
        StoreGoodsItem *item = [[StoreGoodsItem alloc] init];
        item.tag = index;
        [item addTarget:self action:@selector(goodsItemClick:) forControlEvents:UIControlEventTouchUpInside];
        item.itemLabel = label;
        // 默认选中第一个
        if (index == 0) {
            self.currItem = item;
            [item setSelected:YES];
        }
        
        // 排序
        if (index == 3) {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jiage_n"]];
            [itemView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(label.mas_right).offset(fScreen(10));
                make.width.mas_equalTo(fScreen(16));
                make.height.mas_equalTo(fScreen(24));
                make.centerY.equalTo(label);
            }];
            item.itemImageView = imageView;
        }
        
        [itemView addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(itemView);
            make.left.equalTo(itemView).offset(index * buttonWidth);
            make.width.mas_equalTo(buttonWidth);
        }];
    }
    
    UIButton *changeUIButton = [[UIButton alloc] init];
    [changeUIButton setImage:[UIImage imageNamed:@"icon_puping-"] forState:UIControlStateNormal];
    [changeUIButton setImage:[UIImage imageNamed:@"icon_liebiao-"] forState:UIControlStateNormal];
    [changeUIButton addTarget:self action:@selector(changeUIButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [itemView addSubview:changeUIButton];
    [changeUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(itemView);
        make.width.mas_equalTo(fScreen(90));
    }];
    
    return itemView;
}

#pragma mark - button click
- (void)changeUIButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    // 改变 UI
    self.isShowTableView = !self.isShowTableView;
    
    if (self.isShowTableView) {
        // tableView
        [self.goodsListCollView removeFromSuperview];
        [self.view addSubview:self.goodsListTabView];
        [self.goodsListTabView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.top.equalTo(self.itemView.mas_bottom).offset(2);
        }];
    }
    else {
        // collectionView
        [self.goodsListTabView removeFromSuperview];
        [self.view addSubview:self.goodsListCollView];
        [self.goodsListCollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.itemView.mas_bottom).offset(2);
        }];
    }
}

- (void)goodsItemClick:(StoreGoodsItem *)sender
{
    if (sender.tag < 3) {
        if (self.currItem.tag == sender.tag) {
            return;
        }
        else {
            [sender setSelected:YES];
            [self.currItem setSelected:NO];
            self.currItem = sender;
        }
    }
    else {
        if (self.currItem.tag != sender.tag) {
            [self.currItem setSelected:NO];
            self.currItem = sender;
        }
        [sender setSelected:YES];
    }
    
    
    // 请求数据  刷新
}

#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.scrollEnabled) {
        if (scrollView.contentOffset.y == 0) {
            if (self.scrollBlock) {
                self.scrollBlock();
            }
        }
    }
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreGoodsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:tabCellIdentity];
    
    if (!cell) {
        cell = [[StoreGoodsTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tabCellIdentity];
    }
    
    StoreGoodsModel *model = (StoreGoodsModel *)[self.goodsArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    __weak typeof(self) weakSelf = self;
    
    cell.collectBlock = ^(BOOL isCollect) {
    
    };
    cell.shareBlock = ^(ShareModel *shareModel) {
        weakSelf.shareView.shareModel = shareModel;
        [weakSelf.mainView addSubview:weakSelf.shareView];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StoreGoodsModel *model = [self.goodsArray objectAtIndex:indexPath.item];
    
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:model.goodsId];
    [self.currNavigationController pushViewController:goodsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kStoreGoodsTabCellRowHeight;
}


#pragma mark - collection dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.goodsArray count];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreGoodsCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collidentity forIndexPath:indexPath];
    
    StoreGoodsModel *model = (StoreGoodsModel *)[self.goodsArray objectAtIndex:indexPath.item];
    cell.goodsModel = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    StoreGoodsModel *model = [self.goodsArray objectAtIndex:indexPath.item];
    
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:model.goodsId];
    [self.currNavigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - Getter
- (UITableView *)goodsListTabView
{
    if (!_goodsListTabView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setEstimatedRowHeight:kStoreGoodsTabCellRowHeight];
        [tableView setBackgroundColor:viewControllerBgColor];
        [tableView setScrollEnabled:NO];
        [tableView setContentInset:UIEdgeInsetsMake(0, 0, fScreen(60), 0)];
        
        _goodsListTabView = tableView;
    }
    return _goodsListTabView;
}

- (UICollectionView *)goodsListCollView
{
    if (!_goodsListCollView) {
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
        
        layout.sectionInset = UIEdgeInsetsMake(fScreen(30), fScreen(30), fScreen(60), fScreen(30));
        
        _goodsListCollView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_goodsListCollView setBackgroundColor:viewControllerBgColor];
        [_goodsListCollView setShowsVerticalScrollIndicator:NO];
        [_goodsListCollView registerClass:[StoreGoodsCollCell class] forCellWithReuseIdentifier:collidentity];
        [_goodsListCollView setDataSource:self];
        [_goodsListCollView setDelegate:self];
        [_goodsListCollView setScrollEnabled:NO];
    }
    return _goodsListCollView;
}

- (ShareView *)shareView
{
    if (!_shareView) {
        _shareView = [[ShareView alloc] init];
    }
    return _shareView;
}

@end

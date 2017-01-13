//
//  GroupbuyOrderController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyOrderController.h"
#import "CategoryDetailCollCell.h"
#import <Masonry.h>
#import "GroupbuyOrderModel.h"
#import "GroupbuyOrderHeaderView.h"
#import "ShareView.h"
#import "ShareCommissionView.h"

@interface GroupbuyOrderController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *bottomLeftButton;
@property (nonatomic, strong) UIButton *bottomRightButton;

@property (nonatomic, strong) GroupbuyOrderHeaderView *orderHeader;

// data
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) GroupbuyOrderModel *groupOrderModel;

@end

@implementation GroupbuyOrderController

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
    
    [self.orderHeader.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithTitle:(NSString *)title groupId:(NSString *)groupId
{
    if (self = [super init]) {
        self.titleString = title;
        self.groupId = groupId;
    }
    return self;
}

- (void)requestData
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 17; i++) {
        GoodsModel *model = [[GoodsModel alloc] init];
        model.goodsName = @"平和红心蜜柚平和红心蜜柚5斤两颗装adfedfdffffdddddd";
        model.goodsPrice = @"22.8";
        model.marketPrice = @"32.9";
        model.isGroup = YES;
        [tmpArray addObject:model];
    }

    self.dataList = [tmpArray copy];
    
    //
    GroupbuyOrderModel *orderModel = [[GroupbuyOrderModel alloc] init];
    orderModel.goodsName = @"[海贼王] 路飞4挡 pk 大妈海贼团香吉士索隆娜美乔巴";
    orderModel.wuliuInfo =@"顺丰包邮";
    orderModel.groupCount = 8;
    orderModel.groupPrice = @"¥ 987.00/套";
    orderModel.groupPriceBig = @"987.00";
    orderModel.groupTime = 1000;
    orderModel.isMyGroup = YES;
    orderModel.commissionString = @"2/件";
    orderModel.commissionShareText = @"分享佣金¥1.4+返利佣金¥4.7=¥6.1";
    
    NSMutableArray *memberArray = [[NSMutableArray alloc] initWithCapacity:5];
    for (NSInteger index = 0; index < 5; index++) {
        GroupMemberModel *menber = [[GroupMemberModel alloc] init];
        menber.addTime = index%2 == 0 ? 1479950471 : 1479943271;
        menber.userName = @"萨博尼斯";
        [memberArray addObjectSafe:menber];
    }
    orderModel.memberList = [memberArray copy];
    
    self.groupOrderModel = orderModel;
}

- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.titleView = [self addTitleViewWithTitle:self.titleString];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:RGB(197, 198, 198)];
    [self.titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleView);
        make.bottom.equalTo(self.titleView).offset(0.5f);
        make.height.mas_equalTo(0.5f);
    }];
    
    [self addBottomView];
    
    [self.view addSubview:self.collectionView];
}

- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(128));
    }];
    self.bottomView = bottomView;
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:HexColor(0xdadada)];
    [bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bottomView);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [leftButton setTitle:@"更多拼团" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setBackgroundColor:HexColor(0x999999)];
    [leftButton.layer setCornerRadius:fScreen(8)];
    [leftButton addTarget:self action:@selector(bottomLeftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.left.equalTo(bottomView).offset(fScreen(45));
        make.width.mas_equalTo(fScreen(246));
        make.height.mas_equalTo(fScreen(88));
    }];
    self.bottomLeftButton = leftButton;
    
    
    UIButton *rightButton = [[UIButton alloc] init];
    [rightButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setBackgroundColor:HexColor(0xe44a62)];
    [rightButton.layer setCornerRadius:fScreen(8)];
    [rightButton addTarget:self action:@selector(bottomRightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView);
        make.right.equalTo(bottomView).offset(-fScreen(45));
        make.width.mas_equalTo(fScreen(384));
        make.height.mas_equalTo(fScreen(88));
    }];
    self.bottomLeftButton = leftButton;
    
    // 设置按钮
    NSString *buttonTitle = @"";
    if (self.groupOrderModel.isMyGroup) {
        // 我的拼团中
        if (self.groupOrderModel.groupTime > 0) {
            buttonTitle = @"邀请参团";
        }
        else {
            // 我的拼团成功
            if (self.groupOrderModel.isGroupSuccess) {
                buttonTitle = @"查看订单";
            }
            // 我的拼团失败
            else {
                buttonTitle = @"重新开团";
            }
        }
    }
    else {
        // 别人的拼团中
        if (self.groupOrderModel.groupTime > 0) {
            buttonTitle = @"马上参团";
        }
        else {
            // 别人的拼团成功
            if (self.groupOrderModel.isGroupSuccess) {
                buttonTitle = @"我也想买,去开团";
            }
            // 别人的拼团失败
            else {
                buttonTitle = @"我也想买,去开团";
            }
        }
    }
    [rightButton setTitle:buttonTitle forState:UIControlStateNormal];
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
    cell.addShoppingCarBlock = ^(GoodsModel *goodsModel) {
        
    };
    
    return  cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}


#pragma mark - button click
- (void)bottomLeftButtonClick:(UIButton *)sender
{

}

- (void)bottomRightButtonClick:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:@"邀请参团"]) {
        if (self.groupOrderModel.commissionString.length == 0) {
            ShareView *shareView = [[ShareView alloc] init];
            [self.view addSubview:shareView];
            shareView.shareModel = self.groupOrderModel.shareModel;
            shareView.currNaviController = self.navigationController;
        }
        else {
            ShareCommissionView *shareView = [[ShareCommissionView alloc] initWithCommissionText:self.groupOrderModel.commissionShareText];
            [self.view addSubview:shareView];
            shareView.shareModel = self.groupOrderModel.shareModel;
            shareView.currNaviController = self.navigationController;
        }
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
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
        
        CGRect collFrame = CGRectMake(0, fScreen(88) + 20 + 0.5, kAppWidth, kAppHeight - fScreen(88) - 20 - fScreen(128));
        _collectionView = [[UICollectionView alloc] initWithFrame:collFrame collectionViewLayout:layout];
        [_collectionView setBackgroundColor:viewControllerBgColor];
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView registerClass:[CategoryDetailCollCell class] forCellWithReuseIdentifier:collidentity];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        GroupbuyOrderHeaderView *headerView = [[GroupbuyOrderHeaderView alloc] initWithModel:self.groupOrderModel];
        
        __weak typeof(self) weakSelf = self;
        
        headerView.pickUpBlock = ^(BOOL isPickUp, CGFloat listViewHeight) {
            
            CGFloat insertTop = 0;
            CGRect headerFrame = weakSelf.orderHeader.frame;
            CGPoint offset = weakSelf.collectionView.contentOffset;
            
            if (isPickUp) {
                insertTop = weakSelf.orderHeader.height - listViewHeight;
            }
            else {
                insertTop = weakSelf.orderHeader.height;
            }
            
            headerFrame.size.height = insertTop;
            headerFrame.origin.y = -insertTop;
            weakSelf.orderHeader.frame = headerFrame;
            [weakSelf.collectionView setContentInset:UIEdgeInsetsMake(insertTop, 0, 0, 0)];
            if (!isPickUp) {
                [weakSelf.collectionView setContentOffset:CGPointMake(0, offset.y - listViewHeight)];
            }
            else {
                [weakSelf.collectionView setContentOffset:CGPointMake(0, offset.y + listViewHeight)];
            }
        };
        
        self.orderHeader = headerView;
        [_collectionView addSubview:headerView];
        [headerView setFrame:CGRectMake(0, -headerView.height, kAppWidth, headerView.height)];
        
        [_collectionView setContentInset:UIEdgeInsetsMake(self.orderHeader.height , 0, 0, 0)];
        [_collectionView setContentOffset:CGPointMake(0, -self.orderHeader.height)];
    }
    return _collectionView;
}


@end

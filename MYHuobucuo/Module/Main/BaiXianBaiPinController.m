//
//  BaiXianBaiPinController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BaiXianBaiPinController.h"
#import "BaiXianBaiPinModel.h"
#import "BaiXianBaiPinMasterFreeTabCell.h"
#import "BaiXianBaiPinNormalTabCell.h"
#import "BaiXianBaiPinLimitTimeTabCell.h"
#import "GoodsViewController.h"
#import "BaiXianBaiPinHeaderView.h"
#import <SDCycleScrollView.h>

#import "HDRefresh.h"

@interface BaiXianBaiPinController () <UITableViewDataSource, UITableViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) SDCycleScrollView *cycleView;


@property (nonatomic, strong) NSArray *dataList;
@property (nonatomic, strong) NSMutableDictionary *countDownTimeDict;       // 倒计时时间的数组
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation BaiXianBaiPinController

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:13];
    self.countDownTimeDict = [NSMutableDictionary dictionary];
    for (NSInteger index = 0; index < 13; index++) {
        BaiXianBaiPinModel *model = [[BaiXianBaiPinModel alloc] init];
        model.goodsName = @"[十八街] 天津麻花 十八街总店1.8米超级无敌巨无霸麻花";
        model.goodsSpec = @"1条/件";
        model.price = @"452.5";
        model.personCount = 10;
        model.marketPrice = @"888.0";
        
        if (index%3 == 0) {
            model.type = BaiXianBaiPinCellType_Normal;
            
            model.commissionTitle = @"最多可赚";
            model.commissionContent = @"￥ 6.99/件";
        }
        else if (index%3 == 1) {
            model.type = BaiXianBaiPinCellType_LimitTime;
            
            if (index == 1) {
                model.countDownTime = 10800;
            }
            else {
                model.countDownTime = 18000;
            }
        
            [self.countDownTimeDict setObjectSafe:model forKey:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        else {
            model.type = BaiXianBaiPinCellType_MasterFree;
        }
    
        [tmpArray addObjectSafe:model];
    }
    self.dataList = [tmpArray copy];
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.listView.mj_header endRefreshing];
    });
}

- (void)loadMoreData
{
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.listView.mj_footer endRefreshing];
    });
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"百县百品"];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self starTimer];
}

// 开启定时器,用于倒计时
- (void)starTimer
{
    if (!self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
        self.timer = timer;
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)refreshLessTime
{
    for (NSIndexPath *indexPath in self.countDownTimeDict.allKeys) {
        BaiXianBaiPinModel *model = [self.countDownTimeDict objectForKey:indexPath];
        model.countDownTime = --model.countDownTime;
        
        BaiXianBaiPinLimitTimeTabCell *cell = [self.listView cellForRowAtIndexPath:indexPath];
        cell.time = model.countDownTime;
    }
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaiXianBaiPinModel *model = (BaiXianBaiPinModel *)[self.dataList objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    
    switch (model.type) {
        case BaiXianBaiPinCellType_MasterFree:
        default:
        {
            BaiXianBaiPinMasterFreeTabCell *masterCell = (BaiXianBaiPinMasterFreeTabCell *)[tableView dequeueReusableCellWithIdentifier:BaiXianBaiPinMasterFreeTabCellIdentity];
            if (!masterCell) {
                masterCell = [[BaiXianBaiPinMasterFreeTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BaiXianBaiPinMasterFreeTabCellIdentity];
            }
            masterCell.model = model;
            cell = masterCell;
        }
            break;
        case BaiXianBaiPinCellType_Normal:
        {
            BaiXianBaiPinNormalTabCell *normalCell = [tableView dequeueReusableCellWithIdentifier:BaiXianBaiPinNormalTabCellIdentity];
            if (!normalCell) {
                normalCell = [[BaiXianBaiPinNormalTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BaiXianBaiPinNormalTabCellIdentity];
            }
            normalCell.model = model;
            cell = normalCell;
        }
            break;
        case BaiXianBaiPinCellType_LimitTime:
        {
            BaiXianBaiPinLimitTimeTabCell *limitCell = [tableView dequeueReusableCellWithIdentifier:BaiXianBaiPinLimitTimeTabCellIdentity];
            if (!limitCell) {
                limitCell = [[BaiXianBaiPinLimitTimeTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BaiXianBaiPinLimitTimeTabCellIdentity];
            }
            limitCell.model = model;
            cell = limitCell;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:@""];
    [self.navigationController pushViewController:goodsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fScreen(300);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BaiXianBaiPinHeaderView *headerView = (BaiXianBaiPinHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentity];
    
    if (!headerView) {
        headerView = [[BaiXianBaiPinHeaderView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, fScreen(460))];
        headerView.bannerArray = @[@"http://imgsrc.baidu.com/forum/w%3D580/sign=6ef3f55f1a178a82ce3c7fa8c602737f/c5f18a82b9014a901ad6492ead773912b11beea4.jpg", @"http://img5.duitang.com/uploads/item/201506/08/20150608224931_RrnXx.thumb.700_0.jpeg", @"http://img5.duitang.com/uploads/item/201506/07/20150607184837_HdeLa.jpeg", @"http://b.hiphotos.baidu.com/zhidao/pic/item/902397dda144ad34583cdb30d3a20cf430ad8581.jpg"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return fScreen(460 + 20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - SDCycleScrollView delegate

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_listView setDataSource:self];
        [_listView setDelegate:self];
        [_listView setBackgroundColor:viewControllerBgColor];
        [_listView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_listView setEstimatedRowHeight:fScreen(300)];
        
        // header
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
        
        NSArray *images = @[[UIImage imageNamed:@"xialashuaxin"]];
        [header setImages:images forState:MJRefreshStateIdle];
        [header setImages:@[[UIImage imageNamed:@"zhengzaishuaxin"]] forState:MJRefreshStateRefreshing];
        header.lastUpdatedTimeLabel.hidden = YES;
        header.stateLabel.hidden = YES;
        _listView.mj_header = header;
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor blackColor]];
        [line setFrame:CGRectMake(fScreen(339), -300, 0.5, 300 - fScreen(114))];//kAppWidth/2 - fScreen(36)
        [_listView addSubview:line];
        
        // footer
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        NSArray *foots = @[[UIImage imageNamed:@"jiazai"]];
        [footer setImages:foots forState:MJRefreshStateRefreshing];
        footer.stateLabel.hidden = YES;
        footer.refreshingTitleHidden = YES;
        _listView.mj_footer = footer;
    }
    return _listView;
}

@end

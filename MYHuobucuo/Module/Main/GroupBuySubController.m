//
//  GroupBuySubController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupBuySubController.h"
#import "BaiXianBaiPinModel.h"
#import "GroupBuyLimitTimeTabCell.h"
#import "GroupbuyNormalTabCell.h"
#import "GroupbuyMasterFreeTabCell.h"
#import "GroupbuyTabHeaderView.h"
#import "GoodsViewController.h"

@interface GroupBuySubController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) GroupBuyType groupType;       // 拼团类型

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSArray<BaiXianBaiPinModel *> *dataList;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableDictionary *countDownTimeDict;       // 倒计时时间的数组

@end

@implementation GroupBuySubController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];

    [self initUI];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithGroupType:(GroupBuyType)type
{
    if (self = [super init]) {
        self.groupType = type;
    }
    return self;
}

- (void)requestData
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:13];
    self.countDownTimeDict = [NSMutableDictionary dictionary];
    for (NSInteger index = 0; index < 13; index++) {
        BaiXianBaiPinModel *model = [[BaiXianBaiPinModel alloc] init];
        model.goodsName = @"[十八街] 天津麻花 十八街总店1.8米超级无敌巨无霸麻花";
        model.goodsSpec = @"1条/件";
        model.price = @"44";
        model.personCount = 10;
        model.marketPrice = @"998.0";
        
        // 根据 type 来区分请求
        switch (self.groupType) {
            case GroupBuyType_Recommend:
            default:
            {
                if (index%3 == 0) {
                    model.type = BaiXianBaiPinCellType_Normal;
                    
                    model.commissionTitle = @"最多可赚";
                    model.commissionContent = @"￥ 6.99/件";
                }
                else if (index%3 == 1) {
                    model.type = BaiXianBaiPinCellType_LimitTime;
                    
                    model.marketPrice = @"888.0";
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
            }
                break;
            case GroupBuyType_LimitTime:
            {
                model.type = BaiXianBaiPinCellType_LimitTime;
                
                if (index == 1) {
                    model.countDownTime = 10800;
                }
                else {
                    model.countDownTime = 18000;
                }
                
                [self.countDownTimeDict setObjectSafe:model forKey:[NSIndexPath indexPathForRow:index inSection:0]];
            }
                break;
            case GroupBuyType_Normal:
            {
                model.type = BaiXianBaiPinCellType_Normal;
                
                model.commissionTitle = @"最多可赚";
                model.commissionContent = @"￥ 6.99/件";
            }
                break;
            case GroupBuyType_MasterFree:
            {
                model.type = BaiXianBaiPinCellType_MasterFree;
            }
                break;
        }
        
        [tmpArray addObjectSafe:model];
    }
    self.dataList = [tmpArray copy];
}

-(void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(1);
        make.bottom.equalTo(self.view).offset(-fScreen(88));
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
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)refreshLessTime
{
    for (NSIndexPath *indexPath in self.countDownTimeDict.allKeys) {
        BaiXianBaiPinModel *model = [self.countDownTimeDict objectForKey:indexPath];
        model.countDownTime = --model.countDownTime;
        
        GroupBuyLimitTimeTabCell *cell = [self.listView cellForRowAtIndexPath:indexPath];
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
    UITableViewCell *cell;
    
    BaiXianBaiPinModel *model = (BaiXianBaiPinModel *)[self.dataList objectAtIndex:indexPath.row];
    
    switch (model.type) {
        case BaiXianBaiPinCellType_LimitTime:
        default:
        {
            GroupBuyLimitTimeTabCell *limitCell = [tableView dequeueReusableCellWithIdentifier:groupbuyLimitCellIdentity];
            if (!limitCell) {
                limitCell = [[GroupBuyLimitTimeTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupbuyLimitCellIdentity];
            }
            limitCell.model = model;
            cell = limitCell;
        }
            break;
        case BaiXianBaiPinCellType_Normal:
        {
            GroupbuyNormalTabCell *normalCell = [tableView dequeueReusableCellWithIdentifier:groupbuyNormalCellIdentity];
            if (!normalCell) {
                normalCell = [[GroupbuyNormalTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupbuyNormalCellIdentity];
            }
            normalCell.model = model;
            cell = normalCell;
        }
            break;
        case BaiXianBaiPinCellType_MasterFree:
        {
            GroupbuyMasterFreeTabCell *freeCell = [tableView dequeueReusableCellWithIdentifier:groupbuyMasterFreeCellIdentity];
            if (!freeCell) {
                freeCell = [[GroupbuyMasterFreeTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:groupbuyMasterFreeCellIdentity];
            }
            freeCell.model = model;
            cell = freeCell;
        }
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaiXianBaiPinModel *model = [self.dataList objectAtIndex:indexPath.row];
    GoodsViewController *goodsVC = [[GoodsViewController alloc] initWithGoodsId:model.goodsId];
    [self.currNavigationController pushViewController:goodsVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaiXianBaiPinModel *model = [self.dataList objectAtIndex:indexPath.row];
    if (model.type == BaiXianBaiPinCellType_LimitTime) {
        return fScreen(636);
    }
    else if (model.type == BaiXianBaiPinCellType_Normal) {
        return fScreen(595);
    }
    else {
        return fScreen(580);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return fScreen(250 + 20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GroupbuyTabHeaderView *header = [[GroupbuyTabHeaderView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, fScreen(250 + 20))];
    
    NSArray *images = @[@"http://imgsrc.baidu.com/forum/w%3D580/sign=6ef3f55f1a178a82ce3c7fa8c602737f/c5f18a82b9014a901ad6492ead773912b11beea4.jpg", @"http://img5.duitang.com/uploads/item/201506/08/20150608224931_RrnXx.thumb.700_0.jpeg", @"http://img5.duitang.com/uploads/item/201506/07/20150607184837_HdeLa.jpeg", @"http://b.hiphotos.baidu.com/zhidao/pic/item/902397dda144ad34583cdb30d3a20cf430ad8581.jpg"];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger index = 0; index < 4; index++) {
        BannerModel *model = [[BannerModel alloc] init];
        model.imageUrl = images[index];
        [tmpArray addObject:model];
    }
    
    header.imagesArray = tmpArray;
    header.clickBlock = ^(NSInteger index) {
    
    };
    
    return header;
}


#pragma mark - Getter

- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        
        [_listView setDataSource:self];
        [_listView setDelegate:self];
        [_listView setBackgroundColor:viewControllerBgColor];
        [_listView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _listView;
}

@end

//
//  ShopGroupBuyView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ShopGroupBuyView.h"
#import "BaiXianBaiPinModel.h"
#import "BaiXianBaiPinNormalTabCell.h"
#import "BaiXianBaiPinLimitTimeTabCell.h"
#import "BaiXianBaiPinMasterFreeTabCell.h"
#import "GoodsViewController.h"

@interface ShopGroupBuyView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray<BaiXianBaiPinModel *> *groupArray;

@property (nonatomic, strong) UITableView *listView;

@end

@implementation ShopGroupBuyView

- (instancetype)initWithGroupArray:(NSArray *)groupArray
{
    if (self = [super init]) {
        self.groupArray = groupArray;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    [self.listView setContentSize:CGSizeMake(0, fScreen(300)*self.groupArray.count - fScreen(20))];
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaiXianBaiPinModel *model = (BaiXianBaiPinModel *)[self.groupArray objectAtIndex:indexPath.row];
    
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
    
    if (self.clickBlock) {
        
        BaiXianBaiPinModel *model = (BaiXianBaiPinModel *)[self.groupArray objectAtIndex:indexPath.row];
        
        self.clickBlock(model.goodsId);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fScreen(300);
}

#pragma mark - Getter
- (UITableView *)listView
{
    if (!_listView) {
        _listView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        [_listView setDataSource:self];
        [_listView setDelegate:self];
        [_listView setBackgroundColor:viewControllerBgColor];
        [_listView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_listView setEstimatedRowHeight:fScreen(300)];
        [_listView setBounces:NO];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor blackColor]];
        [line setFrame:CGRectMake(fScreen(339), -300, 0.5, 300 - fScreen(114))];//kAppWidth/2 - fScreen(36)
        [_listView addSubview:line];
    }
    return _listView;
}

@end
